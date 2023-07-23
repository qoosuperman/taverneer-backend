# taverneer-backend

## Intro
Taverneer is a web application that makes cocktail recipe searching a breeze.

We hope that everyone who uses this application could make cocktails at home with ease, like a pro tavernier with an engineering mindset.

And this repo is the backend part built by Ruby on Rails.

## Setup Local Environment
### Prerequisite
- [Homebrew](https://brew.sh/index_zh-tw)
- [Docker](https://www.docker.com/)
- [rbenv](https://github.com/rbenv/rbenv)

### Steps
1. Clone the repo
```bash
> git clone git@github.com:qoosuperman/taverneer-backend.git
> cd taverneet-backend
```
2. Install Ruby
```bash
> rbenv install
```
3. Install gems
```bash
> bundle install
```
3. Create environment file for local
```bash
> cp .env.template .env
```
4. Setup database with postgreSQL
TODO: use [dip](https://github.com/bibendi/dip) instead

5. create dev data
```bash
> rake dev:prime
```
6. run the server up
Note: port 8000 is assigned by frontend repo
```bash
> rails s -p 8000
```
