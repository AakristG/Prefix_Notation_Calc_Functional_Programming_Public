# March 2nd 2026 5:23 pm

Starting the initial repository. I got no time to work on it right now, but the general idea behind this project is to functionally code a prefix notation calculator in Racket, which is a form of Lisp language. I have coded a prefix notation calculator in the past in Java and Python, but coding it functinally is going to challenging but fun. I have divided the project in chunks so it's easier for me to code it.

# March 4th 2026 10:55 pm
Forgot to push the initial skeleton into the repo. I will first push this file only and then push my code later

# March 5th 2026 02:47 pm
I was super tired and wasn't able to completely finish my design notes. My thought process for yesterday was I would make each prefix evaluator return a list value that contains remaining chars. For the history feature, I would store the most recent character using cons operation to construct a new value to connect two pieces. Then history ids are resolved by reversing the list. I am gonna also make the main loop tail recursive. Also I would have many functions to handle many features as suggested in the introductory document. Before I start coding I have wrote psuedocode in paper, which I will upload or type out to upload here as well.

# March 5th 2026 03:00 pm
Pseudocode of overall structure: <space>

```
START PROGRAM

detect the prefix mode (interactive or batch)

history = empty list

REPEAT
    read the prefix expression

    IF user wants to "quit"
        exit

    evaluate prefix expression recursively

    IF error
        print error
    ELSE
        print result with history id
        add result to history

END REPEAT
```

# March 5th 2026 7:07 pm
I wanted to get started with thinking about how to pick a mode properly. To implement this feature I knew I needed to use lambda function since it handles in line operations, passes functions as arugments, and also returns functions. I first used the map method to apply a function to every element, but I found a better methods called ormap that checks if any element of a list can satisfy a condition. I would just have ormap check if argument equals -b or --batch and have the it passed to the program.

# March 5th 2026 10:23 pm
I decided to leave the program after the mode selection part. I think I will be adding a function to check for leading whitespace and add the history lookup feature. For now implemented, history feature, value parsing, and error checking. I didn't want to write long error logic every time so I made it a short function. History is built using cons, which means history is reversed internally. The lists are 0-index. For parsing numbers easier, I want to make it into a different function so I can have easier time debugging the code. For my next changes, I want to build my first draft to evaluate prefix notation and make parsing numbers.

# March 6th 2026 04:10 pm
I managed to implement 