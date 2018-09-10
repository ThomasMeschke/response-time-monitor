Service-Monitor
=

The Service-Monitor tool provides the functionality to continuously watch the response time of a set of specified web services.

How to use
- 

Take a look into the sample_config.json. 

You will find a working configuration with a bunch of comments, explaining what you can configure. 

Save your own configuration as 'config.json'. The existence of this file will cause the program to use it. 

Run the program using 'ruby main.rb', and navigate your browser to the server address and port you specified in your config.json file. 

You will see a webpage showing boxes for each service specified, colorized with respect to how short or long the service took to respond.

