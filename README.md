RailsIron
=========

[![Gem Version](https://badge.fury.io/rb/rails_iron.png)](http://badge.fury.io/rb/rails_iron) [![Build Status](https://travis-ci.org/hjblok/rails_iron.png?branch=master)](https://travis-ci.org/hjblok/rails_iron) 

Process background tasks for Rails applications using [IronWorker][4].
The aim is to provide a [Sidekiq][5] compatible interface.


Installation
------------

    gem install rails_iron


Usage
-----

Add a worker into your `app/workers` folder:

    # app/workers/my_hard_worker.rb
    require "rails_iron"

    class MyHardWorker
      include RailsIron::Worker

      def perform
        10.times { "hard work" }
      end
    end

The `require "rails_iron"` is necessary to boot your Iron.io worker.

Now go ahead and create a background task from within your application:

    MyHardWorker.perform_async

You may also supply arguments to the worker:

    # app/workers/my_hard_worker.rb
    require "rails_iron"

    class MyHardWorker
      include RailsIron::Worker

      def perform(work)
        puts "hard #{work}"
      end
    end

    MyHardWorker.perform_async("rock")


Todo
----

This library isn't finished yet, the following is still missing:

- a Rake task for building and uploading the worker
- documentation on how to supply ENV variables
- a mechanism to catch Rails database timeouts during boot time


Testing
-------

To run the tests:

    $ rspec


Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b my_feature`)
3. Commit your changes (`git commit -am "Added Feature"`)
4. Push to the branch (`git push origin my_feature`)
5. Open a [Pull Request][1]
6. Enjoy a refreshing Diet Coke and wait


License
-------

Please see [LICENSE][2] for licensing details.


Author
------

Harm-Jan Blok, [http://sudoit.nl][3]

[1]: https://github.com/hjblok/rails_iron/pulls
[2]: https://github.com/hjblok/rails_iron/blob/master/LICENSE
[3]: http://sudoit.nl
[4]: http://www.iron.io/worker
[5]: https://github.com/mperham/sidekiq
