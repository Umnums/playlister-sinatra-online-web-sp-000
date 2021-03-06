class SongsController < ApplicationController
    enable :sessions
    register Sinatra::Flash
   
    get '/bleh' do
        flash[:message]="Hello?"
    end

     get '/songs' do
        @songs = Song.all
        erb :"/songs/index"
    end

    get '/songs/new' do
        erb :"/songs/new"
    end

    post '/songs' do
        @song = Song.create(params[:song])
        @song.artist= Artist.find_or_create_by(:name => params[:artist]["name"])
        @song.genres << Genre.find(params[:genres])
        @song.save

        flash[:message] = "Successfully created song."
        redirect to "songs/#{@song.slug}"
    end


    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :"/songs/show"
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        erb :"/songs/edit"
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])
        @song.artist= Artist.find_or_create_by(:name => params[:artist]["name"])
        @song.genres.clear
        params[:genres].each do |genre|
            @song.genres << Genre.find(genre)
        end

        @song.save

        flash[:message]="Successfully updated song."
        redirect to "songs/#{@song.slug}"
    
    end


end
