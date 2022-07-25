
## Non-functional requirements 📃
| Characteristics     | Sub-Characteristics    | Requirements  | How to meet them |
| :------------: |:-------------:| :-----:| :------:|
| Performance Efficiency | Time-behavior | As a user, I want to see the result of each bot command for at most 5 seconds | To do it, we can measure the time after sending bot command and stop the stopwatch when the bot responds with the result |
| Reliability | Availability | As a user, I want to have 99% availability of the bot, so most of the time I will have access to the bot | Analyze traffic and choose an appropriate hosting plan for such usage |
| Security | Confidentiality | As a user, I want to maintain my personal information privately | Ruby on Rails framework serves this requirement pretty well