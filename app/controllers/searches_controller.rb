class SearchesController < ApplicationController

  def search
    @value = params[:value]
    @model = params[:model]
    @how = params[:how]
    @datas = search_for(@how, @model, @value)
  end

  private

  def match(model, value)
    if model == "user"
      User.where(name: value)
    elsif model == "book"
      Book.where(title: value)
    end
  end

  def forward(model, value)
    if model == "user"
      User.where("name LIKE ?", "#{value}%")
    elsif model == "book"
      Book.where("title LIKE ?", "#{value}%")
    end
  end

  def backward(model, value)
    if model == "user"
      User.where("name LIKE ?", "%#{value}")
    elsif model == "book"
      Book.where("title LIKE ?", "%#{value}")
    end
  end

  def partial(model, value)
    if model == "user"
      User.where("name LIKE ?", "%#{value}%")
    elsif model == "book"
      Book.where("title LIKE ?", "%#{value}%")
    end
  end

  def search_for(how, model, value)
    case how
    when 'match'
      match(model, value)
    when 'forward'
      forward(model, value)
    when 'backward'
      backward(model, value)
    when 'partial'
      partial(model, value)
    end
  end
end