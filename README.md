PDTimeClock
===========

Basic time tracking clock function 
v1.0


Custom View Controller class: PDTimeClock

Adds a basic time clock function with start, stop and pause/resume functions.

Issues with 1.0:

1. Clock starts counting seconds, in order to prove to the user that something is happening when they click start. Ideally, a message like "time tracking enabled" would appear as well.
2. NSTimer code currently rounds up seconds and so clock can sometimes look like it skipping ahead a few seconds when paused.
3. Start function (after stop) should probably confirm with user if they are OK with resetting clock or not before doing so.

