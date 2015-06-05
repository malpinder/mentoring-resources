Modelling a Music Collection
============================

Draw out a diagram of how you'd model a music collection. Each model should be a box, with a list of it's relations & important fields underneath. Draw lines connecting the models to indicate the relations.

eg:
````
.__________________.               ._________________.
|Track            |                |Album            |
|-----------------|                |-----------------|
|belongs_to :album|   belongs_to   |has_many :tracks |
|                 |--------------->|                 |
|id               |                |id               |
|album_id         |    has_many    |title            |
|title            |<---------------|release_year     |
|_________________|                |_________________|
````

You can make the system as complicated or a simple as you like.

A good starting point would be the basic models of Track, Album and Artist.

Questions
=========

These might help guide your thinking, or prompt you into introducing a new concept into your system. You can answer these however you like, either with code, pseudo-code, an explanation of the process, or just by saying "this system doesn't support that feature".

- How would you find all of the tracks on an album?
- Given a track, how can you find it's artist? How can you find all the tracks an artist has done?
- Given an album, how would you find it's artist? How can you find all the albums an artist has released?
- How would you handle a track that appears on multiple albums? 
- How would you handle compilation albums, where each track is by a different artist?
- The Grey Album is by DangerMouse, Jay-Z and The Beatles. How would you model that? Given that album, how would you find all the other albums each of those artists did?
- Snoop Dogg has done several collaborations with Kelly Rowland. How would you find all the tracks they were both on?
- How would you find the genre or genres of an album? How about the genres of an artist?
- How would you find all the albums with a certain genre? How about all the artists of that genre?
- If you represent popularity as the number of 'likes' on a track, how would you find an artist's most popular track?
- How would you find the most popular artists for a given genre? (i.e. the ones with the most likes on their tracks)
- Prince changed his name to a symbol (or 'the artist formerly known as Prince') and then back again. How would you list all the tracks he's done? How would you represent the artist for each track?
- The White Album by the Beatles was first released in 1986, and a remastered version was released in 2009. How would you represent that?

Further Work
============

Try building a simple Rails app with all of these models & relationships, and run some queries in the console. Can you get to the data you want? Does using the system make you want to change your relations?

Further Reading
===============

http://guides.rubyonrails.org/association_basics.html
