#require 'bundler'
#Bundler.setup

require 'bundler/setup'

require 'sinatra'
require 'erb'
require 'base64'
require 'digest/sha2'
require 'hpricot'

class SRAS < Sinatra::Application
    set :views, Proc.new { File.join(root, "sras/views") }

    get '/' do
        erb :index
    end

    get '/assets/?' do
        erb :index
    end

    post '/assets/?' do
        content_type 'application/xml'

        doc = Hpricot.XML(request.body.read)

        # 404 if the ID already exists.  need to revisit this.
        if Asset.get((doc/:ID).text)
            not_found
        end

        @asset_data = Base64.decode64((doc/:Data).text.chomp)
        @asset_hash = Digest::SHA256.digest(@asset_data).unpack('H*')[0].upcase
        @asset = Asset.new(
            :id             => (doc/:ID).text,
            :asset_type     => (doc/:Type).text,
            :sha256         => @asset_hash,
            :name           => (doc/:Name).text,
            :description    => (doc/:Description).text,
            :local          => (doc/:Local).text,
            :temporary      => (doc/:Temporary).text
        )
        write_asset_data
        @asset.save
        erb :create
    end

    get '/assets/:asset_id' do
        if @asset = Asset.get(params[:asset_id])
            if @asset_data = get_asset_data(params[:asset_id])
                content_type get_asset_type(@asset.asset_type)
                erb :show
            else
                not_found
            end
        else
            not_found
        end
    end

    get '/assets/:asset_id/data' do
        if @asset = Asset.get(params[:asset_id])
            if @asset_data = get_asset_data(params[:asset_id])
                content_type 'application/octet-stream'
                erb :data
            else
                not_found
            end
        else
            not_found
        end
    end

    get '/assets/:asset_id/metadata' do
        if @asset = Asset.get(params[:asset_id])
            if @asset_data = get_asset_data(params[:asset_id])
                content_type get_asset_type(@asset.asset_type)
                erb :metadata
            else
                not_found
            end
        else
            not_found
        end
    end

    delete '/*' do
        # we don't trust anyone to delete assets.  opensim complains if it
        # gets 403s, so return a 404 instead...
        not_found
    end

end

require ::File.dirname(__FILE__) + '/sras/helpers/init'
require ::File.dirname(__FILE__) + '/sras/models/init'
