# Rando

This is intended to my personal replacement for Python's random module. It is still firmly in its 
development stage so I wouldn't recommend anyone else use it yet. :-)

It is currently incompatible with Python 3.13 or higher. I'm just committing so that I don't 
break something horribly. Additionally, this project relies heavily on abuse of IEEE754's 
standard for double-precision floats. If your computer does not use this standard (most do), 
this will not go well. 

I have not done any testing except on raw speed, so I cannot guarantee high quality randomness,  
thread safety, reproducibility, or that it won't crash altogether (although my suspicion, for 
whatever it shouldn't be worth, is that nothing should go terribly wrong). It uses xoroshiro128++ 
by David Blackman and Sebastiano Vigna. 

I set it up by running u.sh -- this may or may not work for you. 

Currently implemented are:

rando.rando() -- same as random.random()

rando.gauss() -- same as random.gauss(), but without mu and sigma arguments; ~5x faster

rando.fast.gauss() -- around 10% faster than rando.gauss(), no guarantees about quality

rando.getrandbits() -- 20-30% than random.getrandbits()

rando.seed() -- probably faster but it doesn't matter

rando.shuffle()

rando.below()

rando.randrange()

And a host of other private functions I haven't figured out how to hide yet. 

Yet to be implemented are:

rando.choice(), rando.choices()

And all the other assorted distributions provided by the random module. 