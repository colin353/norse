class ItemController < ApplicationController
    # This controller looks at items.
    def index
        @items = Item.all
    end
end
