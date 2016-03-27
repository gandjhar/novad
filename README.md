Novad - Novels by Authors.

Purpose: Rails application with multiple models, one-to-many and many-to-many relationships.

## New App

Generate the application

```
> rails new novad
```

## Author Model

Create an Author model.

```
> rails generate model Author name:string country:string bio:text
> rake db:migrate
```


## Seed Authors

Make array of author data.

`db/seeds.rb`

```ruby
authors = [

[ "Mark Twain", "United States",
%{
Samuel Langhorne Clemens, better known by his pen name Mark Twain, was an American author and humorist.

Grew up in Hannibal, Missouri, later the setting for Huckleberry Finn and Tom Sawyer. Apprenticed with a printer. Worked as a typesetter and contributed articles to his older brother Orion's newspaper.  Became a master riverboat pilot on the Mississippi River, before heading west to join Orion.  Was a failure at gold mining, so turned to journalism.
  ...
}],

[ "Ernest Hemmingway" , "United States",
%{
Ernest Miller Hemingway was an American author and journalist. His economical and understated style had a strong influence on 20th-century fiction, while his life of adventure and his public image influenced later generations. Hemingway produced most of his work between the mid-1920s and the mid-1950s, and won the Nobel Prize in Literature in 1954.
...
}],

 ...
]
```

Create authors from the data.

```ruby
authors.each do | name, country, bio |
   Author.create( name: name, country: country, bio: bio )
end
```

Seed the database.

```
> rake db:reset
```

## Author Controller Index/Show

Create a controller for Author with index and show actions.

```
> rails generate controller Authors index show
```

Configure routes for Author as a resource.  Also set root to the author index.

`config/routes.rb`

```
Rails.application.routes.draw do

   resources :authors

   root "authors#index"

end
```

## Authors Index

Make an index view, sorted by author name.

`app/controllers/authors_controller.rb`

```
class AuthorsController < ApplicationController

  def index
     @authors = Author.all.sort_by { |author| author.name }
  end

end
```

`app/views/authors/index.html`

```
<h1>Authors</h1>

<% @authors.each do |author| %>
    <p><%= link_to author.name, author %></p>
<% end %>
```

View with `localhost:3000/authors`

<img src="http://cd.sseu.re/novad/authors-index.png" width="600px" />

## Author Show

Show view for an Author.

```
class AuthorsController < ApplicationController

   # ...

   def show
      @author = Author.find( params[:id] )
   end

end
```

View.

`app/views/authors/show.html.erb`

```
<h1>
   <%= @author.name %>
</h1>

<h3><%= @author.country %></h3>

<p><%= simple_format @author.bio %></p>
```

<img src="http://cd.sseu.re/novad/author-show.png" width="600px" />



## Novel Model

Create Novel model.  Note reference to Author.  Cover will store an image url string.

```
> rails generate model Novel title:string author:references year:integer cover:string plot:text
> rake db:migrate
```

# Novel Seeds

Make a list of novels by author.  Use cover images found on the internet.

`db/seeds.rb`

```
author_novels = {}

author_novels["Mark Twain"] = [

   [ "The Adventures of Tom Sawyer",
     1876, "http://csmt.cde.ca.gov/images/0030544610.jpg",
     "Adventures of a young boy and his friends growing up in a small Missouri town on the banks of the Mississippi River in the nineteenth century."
   ],

   [ "A Connecticut Yankee in King Arthur's Court",
     1889, "https://img1.etsystatic.com/000/0/6648867/il_fullxfull.333586431.jpg",
     "A nineteenth-century American travels back in time to sixth-century England"
   ],
]


author_novels["Ernest Hemmingway"] = [

   [ "The Old Man and the Sea",
     1952, "http://7summitsproject.com/wp-content/uploads/2015/06/old-man-and-the-sea-review.jpg",
     "Old Cuban fisherman sails further out to sea than usual in attempt to better his luck."
   ],

   [ "A Farewell to Arms",
     1929, "https://kuwwi.files.wordpress.com/2015/07/farewell-to-arms-people.jpg",
     "Young American WW1 soldier in Italy is injured and cared for by English nurse's aide."
   ],

   [ "For Whom the Bell Tolls",
     1940, "http://1.bp.blogspot.com/-hgJGEoU-cuw/Tz6t7RmvjqI/AAAAAAAACug/NFuuUzkTJc4/s1600/forwhom.jpg",
     "American joins guerrillas in the Spanish Civil war."
   ],
]
```

Process the list of novels by author.

`db/seeds.rb`

```
author_novels.each do | author_name, novels |
   author = Author.find_by( name: author_name )

   novels.each do | title, year, cover, plot |
      Novel.create( title:title, author_id: author.id, year: year, cover: cover, plot: plot )
   end
end
```

## Novel Controller Index/Show

```
> rails generate controller Novels index show
```

Novel routes.

```
Rails.application.routes.draw do

  resources :authors
  resources :novels

end
```

Make a Novels index.

`app/views/novels/index.html.erb`

```
<h1>Novels</h1>

<%= render @novels %>
```

Use partial for individual novels.

`app/views/novels/_novel.html.erb`

```
<div class="novel-item">

   <div class="inline cover">
      <img class="small-cover" src="<%= novel.cover %>"/>
   </div>

   <div class="inline details">

      <h3><%= link_to novel.title, novel %></h3>
      <h4><%= link_to novel.author.name, novel.author %></h4>

      <p><%= novel.year %></p>
      <p><%= novel.plot %></p>

   </div>

</div>
```

Some CSS styling.  Rename 'application.css' to 'application.scss', i.e. change file extenstion to be '.scss'

`assets/stylesheets/application.scss`

```
img.small-cover {
    width: 200px;
    height: 300px;
}

div.inline {
    display: inline-block;
    vertical-align: text-top;
}

div.novel-item {
   margin-top: 14px;

   .cover {
      margin-right: 10px;
   }

   .details {
      width: 400px;
   }
}
```

<img src="http://cd.sseu.re/novad/novels-index.png" width="600px" />

## Show Novel

Add Show Novel view.

```
class NovelsController < ApplicationController

   # ...

  def show
    @novel = Novel.find( params[:id] )
  end
end
```

View.

`app/views/novels/show.html.erb`

```
<h1>
   <%= @novel.title %>
</h1>

<h3><%= link_to @novel.author.name, @novel.author %> </h3>

<p><%= @novel.year %></p>
<p><%= @novel.plot %></p>

<img class="cover" src="<%= @novel.cover %>"/>
```

CSS for the full size cover.

```
img.cover {
    width: 400px;
    height: 600px;
}
```

<img src="http://cd.sseu.re/novad/novel-show.png" width="600px" />

## Author Show with Novels

Would be nice to show an authors novels on their page.

Add relationship to the Author model.

`app/models/author.rb`

```
class Author < ActiveRecord::Base
   has_many :novels
end
```

Show the list of novels in the view.

`app/views/authors/show.html.erb`

```
<h1>
   <%= @author.name %>
</h1>

<h3><%= @author.country %></h3>

<p><%= simple_format @author.bio %></p>

<h2>Novels</h2>

<% novels = @author.novels.sort_by { |novel| novel.year } %>

<%= render novels, hide_author: true %>
```

Add a hide author param to the partial, since don't need to show the Author again with each novel on the Author's own page.

`app/views/novels/_novel.html.erb`

```
<div class="novel-item">

   <div class="inline cover">
      <img class="small-cover" src="<%= novel.cover %>"/>
   </div>

   <div class="inline details">

      <h3><%= link_to novel.title, novel %></h3>

      <% if !defined?(hide_author) || !hide_author %>
          <h4><%= link_to novel.author.name, novel.author %></h4>
      <% end %>

      <p><%= novel.year %></p>
      <p><%= novel.plot %></p>

      <p>
         <% novel.genres.each do |genre| %>
             <%= link_to "#{genre.name}", genre, class: "btn btn-primary btn-xs" %>
         <% end %>
      </p>

   </div>

</div>
```

<img src="http://cd.sseu.re/novad/author-novels.png" width="600px" />

## Bootstrap

Add Bootstap to make it look nice.

`Gemfile`

```ruby
# ...
gem 'bootstrap-sass', '~> 3.3.6'
```

`app/assets/stylesheets/application.scss`

```ruby
# ...
@import "bootstrap-sprockets";
@import "bootstrap";
```

`app/assets/javascript/application.js`

```ruby
# ...
//= require bootstrap-sprockets
```

Bundle install then restart the server!

Wrap the yield in the layout with a bootstrap container div with id 'main'.

`app/views/layouts/application.html.erb`
```
<body>

<div id="main" class="container-fluid">
   <%= yield %>
</div>

</body>
```

Give some padding to main in the css.

```
div#main {
   margin: 100px;
}
```

<img src="http://cd.sseu.re/novad/bootstrap.png" width="600px" />

## Nav Bar

Add a navbar header to the layout with authors and novels links.

`app/views/layouts/_nav.html.erb`

```
<nav class="navbar navbar-fixed-top navbar-default">
   <div class="container-fluid">

      <div class="navbar-header">
         <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
         </button>
         <%= link_to "Novad", root_path, class: "navbar-brand" %>
      </div>

      <div id="navbar" class="navbar-collapse collapse">
         <ul class="nav navbar-nav">
            <li><%= link_to "Authors", authors_path %></li>
            <li><%= link_to "Novels", novels_path %></li>
         </ul>
         <ul class="nav navbar-nav navbar-right">
            <li><%= link_to "About", '#' %></li>
         </ul>
      </div>

   </div>
</nav>
```

Include in the layout.

`app/views/layouts/application.html.erb`

```
<body>

<div id="main" class="container-fluid">
   <%= render "layouts/nav" %>

   <%= yield %>
</div>

</body>
```

## Genre Model

Now add genres for novels.  First create a model for the various genres.

```
> rails generate model Genre name:string
```

Seed some genres.

`db/seeds.rb`

```ruby
genres = [
   "Absurdist",
   "Bildungsroman",
   "Action",
   "Adventure",
   "Comedy",
   "Crime",
   "Drama",
   "Fantasy",
   "Family",
   "Historical",
   "Horror",
   "Magical Realism",
   "Mystery",
   "Paranoid",
   "Philosophical",
   "Political",
   "Romance",
   "Saga",
   "Satire",
   "Science Fiction",
   "Speculative",
   "Surreal",
   "Thriller",
   "Urban",
   "Western",
]

genres.each do |genre_name|
   genre = Genre.create( name: genre_name )
end
```

## Join Novels with Genres

Express that Novel may have many Genres and visa versa.

`app/models/novel.rb`

```
class Novel < ActiveRecord::Base
  belongs_to :author
  has_and_belongs_to_many :genres
end
```

`app/models/genre.rb`

```
class Genre < ActiveRecord::Base
   has_and_belongs_to_many :novels
end
```

Create a join table to store the relationship.

```
> rails generate model Genres_Novels genre:references novel:references --force-plural
```

Seed each novel with some genres.  Split a string listing the genres.  Add any new genres that are found.

`db/seeds.rb`

```
author_novels["Leo Tolstoy"] = [
   [ "War and Peace",
     1869, "http://i.huffpost.com/gen/997213/images/o-WAR-AND-PEACE-facebook.jpg",
     "History of the French invasion of Russia, and the impact of the Napoleonic era on Tsarist society, through the stories of five Russian aristocratic families.",
     "War, Drama, Historical, Philosophical, Realism, Family, Romance" ],

   [ "Anna Karenina",
     1877, "https://s-media-cache-ak0.pinimg.com/736x/1b/0b/0a/1b0b0a9852b0eb2d48648d05e9f7f695.jpg",
     "St. Petersburg aristocrat's life story at the backdrop of the late-19th-century feudal Russian society.",
     "Family, Drama, Romance, Tragedy, Realism, Psychological" ],

   [ "The Death of Ivan Ilych",
     1886, "https://s-media-cache-ak0.pinimg.com/736x/b4/2c/78/b42c786e8bb5eb170785a9d2ff64b7b1.jpg",
     "A worldly careerist, a high court judge who has never given the inevitability of his dying so much as a passing thought until one day, death announces itself, and to his shocked surprise, he is brought face to face with his own mortality.",
     "Realism, Satire, Parody, Exemplum, Satire" ],
]
```

```
author_novels.each do | author_name, novels |
   author = Author.find_by( name: author_name )

   novels.each do | title, year, cover, plot, genres |
      novel = Novel.create( title:title, author_id: author.id, year: year, cover: cover, plot: plot )

      genres.split( ", ").each do |genre_name|
         if genre = Genre.find_by( name: genre_name )
         else
            genre = Genre.create( name: genre_name )
         end

         GenresNovels.create( novel: novel, genre: genre )
      end
   end
end
```

## Show Genres

Configure Genre routes.

```
Rails.application.routes.draw do

  resources :authors
  resources :novels
  resources :genres

  root "authors#index"

end
```

Display a Novel's Genres as buttons on its Show Page.

`app/views/novels/show.html.erb`

```
<h1>
   <%= @novel.title %>
</h1>

<h3><%= link_to @novel.author.name, @novel.author %> </h3>

<p><%= @novel.year %></p>
<p><%= @novel.plot %></p>

<p>
   <% @novel.genres.each do |genre| %>
       <%= link_to "#{genre.name}", genre, class: "btn btn-primary btn-xs" %>
   <% end %>
</p>

<img class="cover" src="<%= @novel.cover %>"/>
```

Give the buttons a little extra margin.

```
.btn {
   margin: 4px;
}
```

<img src="http://cd.sseu.re/novad/novel-genres.png" width="600px" />

Also display the genres in the novel lists via the novel partial template.

`app/views/novels/_novel.html.erb`

```
<div class="novel-item">

   <div class="inline cover">
      <img class="small-cover" src="<%= novel.cover %>"/>
   </div>

   <div class="inline details">

      <h3><%= link_to novel.title, novel %></h3>
      <h4><%= link_to novel.author.name, novel.author %></h4>

      <p><%= novel.year %></p>
      <p><%= novel.plot %></p>

      <p>
         <% novel.genres.each do |genre| %>
             <%= link_to "#{genre.name}", genre, class: "btn btn-primary btn-xs" %>
         <% end %>
      </p>

   </div>

</div>
```

<img src="http://cd.sseu.re/novad/novels-list-genres.png" width="600px" />

## Show Genre

Showing a Genres list all novels with that Genre.

Create a Genres controller with index and show views.

```
> rails generate controller Genres index show
```

Showing a genre list all of its novels.

`app/controllers/genres_controller.rb`

```
class GenresController < ApplicationController

  def show
     @genre = Genre.find( params[:id] )
  end

end
```

`app/views/genres/show.html.erb`

```
<h1><%= @genre.name %></h1>

<%= render @genre.novels %>
```

<img src="http://cd.sseu.re/novad/genre-show.png" width="600px" />

## Genres Index

Can create a genres index.

```
class GenresController < ApplicationController

  # ...

  def index
    @genres = Genre.all.sort_by { |genre| genre.novels.size }.reverse
  end
end
```

`app/views/genres/index.html.erb`

```
<h1>Genres</h1>

<div>
   <% @genres.each do |genre| %>
      <%= link_to "#{genre.name} • #{genre.novels.size}", genre, class: "btn btn-primary" %>
   <% end %>
</div>
```

<img src="http://cd.sseu.re/novad/genres-index.png" width="600px" />


Add it to the navbar.

`app/views/layouts/_nav.html.erb`

```
<ul class="nav navbar-nav">
   <li><%= link_to "Authors", authors_path %></li>
   <li><%= link_to "Novels", novels_path %></li>
   <li><%= link_to "Genres", genres_path %></li>
</ul>
```

<img src="http://cd.sseu.re/novad/genres-nav.png" width="600px" />


## New Author

Add a new author.

Button to add new.

`app/views/authors/index.html.erb`

```
<h1>Authors <%= link_to "New Author", new_author_path, class: "btn btn-default", style: "float: right" %></h1>
...
```

<img src="http://cd.sseu.re/novad/author-new-btn.png" width="600px" />

New Author Form with bootstrap classes.

`app/views/authors/new.html.erb`

```
<h1>New Author</h1>

<%= render "form" %>
```

`app/views/authors/_form.html.erb`

```
<%= form_for @author do |f| %>

    <div class="form-group">
       <%= f.label :name %>
       <%= f.text_field :name, class: "form-control", placeholder: ". . ." %>
    </div>

    <div class="form-group">
       <%= f.label :country %>
       <%= f.text_field :country, class: "form-control", placeholder: ". . ."   %>
    </div>

    <div class="form-group">
       <%= f.label :bio %>
       <%= f.text_area :bio, class: "form-control", rows: 10  %>
    </div>

    <%= f.submit (@author.new_record? ? "Create" : "Update"), class: "form-control btn-primary" %>

<% end %>
```

<img src="http://cd.sseu.re/novad/author-new-form.png" width="600px" />

Controller actions to create a new author.

```
class AuthorsController < ApplicationController

   # ...

   def new
      @author = Author.new
   end

   def create
      author = Author.new( author_params )

      if author.save
         redirect_to authors_path
      else
         render 'new'
      end
   end

 private

   def author_params
      params.require( :author ).permit( :name, :country, :bio )
   end

end
```

## New Novel

New Novel button on Author page.  Create a new novel by that author.

Note the author_id parameter to new_novel_path.  Is passed in the params hash to the NovelsController::new action.

`app/views/authors/show.html.erb`

```
<h1>
   <%= @author.name %>
</h1>

<h3><%= @author.country %></h3>

<p><%= simple_format @author.bio %></p>

<%= link_to "New Novel", new_novel_path( author_id: @author.id ), class: "btn btn-default", style: "float: right" %></h2>

<% novels = @author.novels.sort_by { |novel| novel.year } %>

<%= render novels %>
```

<img src="http://cd.sseu.re/novad/novel-new-btn.png" width="600px" />

Controller New Action

```
class NovelsController < ApplicationController

   # ...

   def new
      @novel = Novel.new
      @novel.author_id = params[:author_id]
   end

end
```

New Novel Form.  

`app/views/novels/new.html.erb`

```
<h1>New Novel by <%= @novel.author.name %></h1>

<%= render "form" %>
```

Note hidden field to pass author_id on to the create action through params again.

Note also the multi select for genres.

`app/views/novels/_form.html.erb`

```
<%= form_for @novel do |f| %>

    <%= f.hidden_field :author_id, :value => @novel.author.id%>

    <div class="form-group">
       <%= f.label :title %>
       <%= f.text_field :title, class: "form-control", placeholder: ". . ." %>
    </div>

    <div class="form-group">
       <%= f.label :year %>
       <%= f.text_field :year, class: "form-control", placeholder: ". . ."   %>
    </div>

    <div class="form-group">
       <%= f.label :cover %>
       <%= f.text_field :cover, class: "form-control", placeholder: "url . . ."   %>
    </div>

    <div class="form-group">
       <%= f.label :plot %>
       <%= f.text_area :plot, class: "form-control", rows: 6  %>
    </div>

    <div class="form-group">
       <%= f.label :genres, :class => "control-label" %>
       <div>
          <% genres = Genre.all.map{|t| [t.name, t.id]}.sort %>
          <%= f.select :genre_ids, genres, { class: "form-control", prompt: true }, { multiple: true, size: 10 } %>
          <p class="help-block">Select multiple with Ctrl</p>
       </div>
    </div>

    <%= f.submit (@novel.new_record? ? "Create" : "Update"), class: "form-control btn-primary" %>

<% end %>
```

Novel create action.  Note special syntax for multiple genres ids.

Passing the array of genre ids to new as part of novel_params causes rails to make all the required join entires in the genres_novels table.

```
class NovelsController < ApplicationController

   def create
      novel = Novel.new( novel_params )

      if novel.save
         redirect_to author_path( novel.author_id )
      else
         render new_novel_path
      end
   end

private

   def novel_params
     params.require( :novel ).permit( :title, :year, :cover, :plot, :author_id, genre_ids: [] )
   end
end
```

<img src="http://cd.sseu.re/novad/novel-new-form.png" width="600px" />


## Edit Novel

Edit Novel button on Novel Show page.

`app/views/novels/show.html.erb`

```html
<h1>
   <%= @novel.title %>
   <%= link_to "Edit", edit_novel_path( @novel ), class: "btn btn-default", style: "float: right" %>
</h1>

<!-- ... -->
```

<img src="http://cd.sseu.re/novad/novel-edit-btn.png" width="600px" />

Novel Edit form (uses same partial are New Novel)

`app/views/novels/edit.html.erb`

```
<h1>Edit Novel by <%= @novel.author.name %></h1>

<%= render "form" %>
```

Controller actions.

```
class NovelsController < ApplicationController

   # ...

   def edit
     @novel = Novel.find( params[:id] )
   end

   def update
     @novel = Novel.find( params[:id] )

     if @novel.update_attributes( novel_params )
       redirect_to @novel
     else
       render 'edit'
     end
   end

end
```

## Delete Novel

Add a Delete button to Novel Show page.

`app/views/novels/show.html.erb`

```
<h1>
   <%= @novel.title %>
   <%= link_to "Delete", novel_path( @novel ), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default", style: "float: right" %>
   <%= link_to "Edit", edit_novel_path( @novel ), class: "btn btn-default", style: "float: right" %>
</h1>

<!-- ... -->
```

<img src="http://cd.sseu.re/novad/novel-delete-btn.png" width="600px" />

Has confirmation dialog.

<img src="http://cd.sseu.re/novad/novel-delete-confirm.png" width="600px" />

Destroy method for Controller.

```
class NovelsController < ApplicationController

   # ...

   def destroy
     @novel = Novel.find( params[:id] )

     author_id = @novel.author_id

     @novel.destroy

     redirect_to author_path( author_id )
   end

end
```

## Edit & Delete Author

Add edit and delete buttons to author

`app/views/authors/show.html.erb`

```
<h1>
   <%= @author.name %>
   <%= link_to "Delete", author_path( @author ), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default", style: "float: right" %>
   <%= link_to "Edit", edit_author_path( @author ), class: "btn btn-default", style: "float: right" %>
</h1>
```

<img src="http://cd.sseu.re/novad/author-edit-delete-btns.png" width="600px" />

Edit view reuses Author form partial.

`app/views/authors/edit.html.erb`

```
<h1>Edit Author</h1>

<%= render "form" %>
```

Controller actions

```
class AuthorsController < ApplicationController

   # ...

   def edit
      @author = Author.find( params[:id] )
   end

   def update
      @author = Author.find( params[:id] )

      if @author.update_attributes( author_params )
         redirect_to @author
      else
         render 'edit'
      end
   end

   def destroy
      @author = Author.find( params[:id] )

      @author.destroy

      redirect_to authors_path
   end

end
```

Add **depdendent destroy** to relationship so that when an Author is destroyed, all of their Novels are also destroyed.

`app/models/author.rb`

```
class Author < ActiveRecord::Base
   has_many :novels, dependent: :destroy
end
```

## Site Home

Create a Site controller.

```
> rails generate controller Site home about
```

`app/controllers/site_controller.rb`

```
class SiteController < ApplicationController
  def home
  end

  def about
  end
end
```

Routes.

```
Rails.application.routes.draw do

  resources :authors
  resources :novels
  resources :genres

  get "about" => "site#about"

  root "site#home"

end
```

Home page.

`app/views/site/home.html.erb`

```
<h1>Novad</h1>

<a href="<%= authors_path %>"><div class="nav-box authors"><h2>Authors</h2></div>'</a>
<a href="<%= novels_path %>"><div class="nav-box novels"><h2>Novels</h2></div>'</a>
<a href="<%= genres_path %>"><div class="nav-box genres"><h2>Genres</h2></div>'</a>
```

<img src="http://cd.sseu.re/novad/home.png" width="600px" />

About page.

`app/views/site/about.html.erb`

```
<h1>Novad</h1>

<p>Celebrating literature with Novels by Authors.</p>
```

Update the navbar with about path.

`app/views/layouts/_nav.html.erb`

```
<ul class="nav navbar-nav navbar-right">
   <li><%= link_to "About", about_path %></li>
</ul>
```

<img src="http://cd.sseu.re/novad/about.png" width="600px" />
