require 'tilt'
require 'sinatra'
require 'better_errors'

Dir.glob(File.join('./app', '**', '*.rb'), &method(:require))

APP      = 'APP'.freeze
ACCEPTED = 'erb,haml,md'.freeze
DEFAULT  = 'haml'.freeze
VIEWS    = 'views'.freeze

set :public_folder, 'public'

configure do
  set :dump_errors, false
  set :raise_errors, true
  set :show_exceptions, false
end

helpers do
  def render(target)
    file = Dir.glob("#{APP}/#{VIEWS}/#{target}.{#{ACCEPTED}}")
    template = Tilt.new("#{APP}/#{VIEWS}/_layout.#{DEFAULT}")
    renderer = Tilt.new("#{APP}/#{VIEWS}/index.#{DEFAULT}") if view.empty?
    renderer = Tilt.new(file.first) unless file.empty?
    renderer = Tilt.new("#{APP}/#{VIEWS}/_404.#{DEFAULT}") unless renderer
    return unless renderer
    template.render do
      renderer.render self, __view: view
    end
  end

  def view
    params[:splat].first[1..-1]
  end
end

get('*') { render view }
post('*') { render view }

run Sinatra::Application
