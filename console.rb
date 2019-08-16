require_relative('./models/casting')
require_relative('./models/movie')
require_relative('./models/star')
require('pry-byebug')

Casting.delete_all()
Movie.delete_all()
Star.delete_all()


movie1 = Movie.new({
  "title" => "JAWS",
  "genre" => "thriller",
  "budget" => 600
  })

  movie2 = Movie.new({
    "title" => "Jumanji",
    "genre" => "family",
    "budget" => 1000
    })

    movie1.save()
    movie2.save()

    star1 = Star.new({
      "first_name" => "Richard",
      "last_name" => "Dreyfus"
      })

      star2 = Star.new({
        "first_name" => "Dwayne",
        "last_name" => "Johnson"
        })

        star3 = Star.new({
          "first_name" => "Kevin",
          "last_name" => "Hart"
          })


          star1.save()
          star2.save()
          star3.save()

          casting1 = Casting.new({
            "movies_id" => movie1.id,
            "stars_id" => star1.id,
            "fee" => 5 })

            casting2 = Casting.new({
              "movies_id" => movie2.id,
              "stars_id" => star2.id,
              "fee" => 500 })

              casting3 = Casting.new({
                "movies_id" => movie2.id,
                "stars_id" => star3.id,
                "fee" => 300 })

                casting1.save()
                casting2.save()
                casting3.save()

                binding.pry
                nil
