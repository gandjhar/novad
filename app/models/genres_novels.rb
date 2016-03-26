class GenresNovels < ActiveRecord::Base
  belongs_to :genre
  belongs_to :novel
end
