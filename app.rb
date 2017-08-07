require 'sinatra'
require 'ipaddr'
require 'yaml'
require 'json'

before do
  allowed_ranges = [
    IPAddr.new('104.192.143.0/24'),
    IPAddr.new('34.198.203.127'),
    IPAddr.new('34.198.178.64'),
    IPAddr.new('34.198.32.85')
  ]

  allowed = false

  allowed_ranges.each do |range|
    allowed = true if range.include?(request.ip)
  end

  halt 403, 'Access denied' unless allowed
  halt 404, 'Not found' unless request.env['HTTP_X_EVENT_KEY'] == 'repo:push'
end

error 404 do
  'Not found'
end

post '/push' do
  request.body.rewind
  payload = JSON.parse request.body.read

  whereami = File.dirname(__FILE__)

  config = YAML.safe_load(File.read(File.join(whereami, 'bithookd.yml')))

  return logger.error 'No repos key in config' unless config.key? 'repos'
  repo = payload['repository']['full_name']
  return logger.error "Unknown repo: #{repo}" unless config['repos'].key? repo
  repo = config['repos'][repo]

  changes = payload['push']['changes']

  return logger.error 'No changes' if changes.size.zero?

  branch = changes.first['new']['name']

  return logger.error "Unknown branch: #{branch}" unless repo.key? branch

  repo = repo[branch]

  return logger.error 'No path key for branch' unless repo.key? 'path'
  return logger.error 'No commands key for branch' unless repo.key? 'commands'

  path = repo['path']

  return logger.error "Not found: #{repo['path']}" unless Dir.exist? path

  Thread.start do
    # Run commands in "path"
    Dir.chdir path do
      repo['commands'].each do |command|
        system command
      end
    end
  end

  'OK'
end
