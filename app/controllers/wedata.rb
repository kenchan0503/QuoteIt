require 'open-uri'
Thumbnailr.controllers :wedata do
  get :index, :map => '/wedata' do
    open('http://wedata.net/databases/QuoteIt-thumbnail/items.json') do|io|
      @thumbnails = JSON.parse(io.read).map{|item|
        item['status'] = Thumbnail.status item
        item
      }
    end

    open('http://wedata.net/databases/QuoteIt-clip/items.json') do|io|
      @clips = JSON.parse(io.read).map{|item|
        item['status'] = Html.status item
        item
      }
    end
    render 'wedata/index'
  end

  post :update, :map => '/wedata/update' do
    open('http://wedata.net/databases/QuoteIt-thumbnail/items.json') do|io|
      items = JSON.parse(io.read)
      count = Thumbnail.update! items
    end

    open('http://wedata.net/databases/QuoteIt-clip/items.json') do|io|
      items = JSON.parse(io.read)
      count = Html.update! items
    end
    flash[:notice] = "Update plugins"
    redirect url_for(:wedata_index)
  end
end
