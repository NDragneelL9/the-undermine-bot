[![The-Undermine-Bot.jpg](https://i.postimg.cc/Kzy0nV4g/The-Undermine-Bot.jpg)](https://postimg.cc/qtjcr1sk) <br>
# The Undermine Bot
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/NDragneelL9/the-undermine-bot/blob/main/LICENSE) [![Maintainability](https://api.codeclimate.com/v1/badges/1f1bd3da8f1a9d0de489/maintainability)](https://codeclimate.com/github/NDragneelL9/the-undermine-bot/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/1f1bd3da8f1a9d0de489/test_coverage)](https://codeclimate.com/github/NDragneelL9/the-undermine-bot/test_coverage)  <br>
**Author**: [Tim](https://github.com/NDragneelL9) <br>

## Table of content

- [What is the goal of this project?](#what-is-the-goal-of-this-project)
- [Requirements 📃](#requirements)
  - [Functional requirements (Backlog)](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/FunctionalRequirements.md)
  - [Non-functional requirements](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/NonFunctionalRequirements.md)
- [Glossary 📝](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/Glossary.md)
- [Stakeholders 👤](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/Stakeholders.md)
- [Design 📊](#design)
  - [Database diagram](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/DatabaseDiagram.md)
  - [Sequence diagram](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/SequenceDiagram.md)
  - [Use Case diagram](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/UseCaseDiagram.md)
- [Architecture 🖼️](#Architecture)
  - [Static View](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/StaticView.md)
  - [Dynamic View](https://github.com/NDragneelL9/the-undermine-bot/blob/main/documentation/DynamicView.md)
- [Technical Stack](#technical-stack)
- [Getting started](#getting-started)
- [Contributing](#contributing)

# What is the goal of this project?
**The Undermine Bot** was inspired by [THE UNDERMINE JOURNAL](https://theunderminejournal.com) and is supposed to help WoW players with getting live updates on the market.

# Technical Stack
The project consists of two main parts: **[Telegram bot](https://core.telegram.org/bots)** as User interface and **[Ruby on Rails](https://rubyonrails.org/)** as back-end service ([PostreSQL](https://www.postgresql.org/) as main database)

# Getting started
1. Clone repository 
```
git clone https://github.com/NDragneelL9/the-undermine-bot.git
```
2. Change directory to `the-undermine-bot` and install app gems
```
cd the-undermine-bot
bundle install
```
3. `Enter` telegram bot and Blizzard client `credentials` using:
```
EDITOR=nano rails credentials:edit
```
4. Run poller
```
rails telegram:bot:poller
```
5. Send commands to telegram bot
```
/start
```

# Contributing
Just fork the repository from the develop branch, follow [Getting started](#getting-started) section, implement changes you want to propose and make a pull request. Also, there are issues in repository, feel free to submit a new one or participate in existing.