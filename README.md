# Poser

A Markov chain tweet generator

### CLI Usage

```.sh
bin/poser USERNAME [OPTIONS]
```

Foe example, to generate a tweet based on the [JustNietzche](https://twitter.com/justnietzsche) account:

```.sh
bin/poser justnietzche

# => "Art is the Insofar as we believe in morality we pass sentence on existence. He is always the scapegoat."
```

_Please note that the first run on any new user may take a while while the tweet cache is set up. Subsequent runs will use the cache, so will be much faster._

### Setup

The recommended Ruby version is 2.3.x, due to the [Twitter client gem](https://github.com/sferik/twitter#supported-ruby-versions) being only supported up to this Ruby version. Use with other Ruby versions at your own risk!

[Redis](https://github.com/antirez/redis) is a dependency. If on a Mac:

```.sh
brew install redis
brew services start redis
```

Other install options can be found at https://redis.io/.

After you have Redis set up, clone the repo, install the gems, and set up the secrets file:

```.sh
git clone https://github.com/jpalmieri/poser
cd poser
bundle install
cp secrets.yml.sample secrets.yml
```

Then open up `secrets.yml` and add your twitter secrets. You may need to [register the app](https://apps.twitter.com/) in your twitter account to get these secrets.
