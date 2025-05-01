# Uptimer

![Uptimer Screenshot](/Users/hendrikvosskamp/Desktop/Screenshot%202025-04-30%20at%2019.45.23.png)

## Website Monitoring Made Simple

Uptimer is a web application that allows you to monitor multiple websites at a glance. Built with Elixir and Phoenix LiveView, it provides a real-time dashboard to monitor the availability and visual state of your web properties.

**[Try the Live Demo](https://uptimer.vossihub.org)**

## Features

- **Near-Real-time monitoring**: Monitor your websites with live iframe previews or thumbnails
- **Status tracking**: Instantly see which websites are up and which are down
- **Visual verification**: Quickly check if your websites look as expected with live previews
- **Thumbnail fallback**: Uses screenshot thumbnails for sites with cross-origin restrictions
- **Automatic refreshes**: Near real-time status updates every 10 seconds
- **Mobile responsive**: Monitor your websites from any device
- **User accounts**: Secure authentication system to manage your monitored websites
- **Free tier**: Monitor up to 32 websites with 4 thumbnails for free

## Technology Stack

- **Backend**: Elixir with Phoenix Framework
- **Frontend**: Phoenix LiveView, TailwindCSS
- **Database**: SQLite
- **Authentication**: Built-in Phoenix authentication
- **Deployment**: Docker ready (see Dockerfile)

## Development Setup

### Prerequisites

- Elixir 1.14+
- Erlang OTP 25+
- Node.js 18+ (for assets)

### Installation

1. Clone the repository

   ```bash
   git clone https://github.com/yourusername/uptimer.git
   cd uptimer
   ```

2. Install dependencies

   ```bash
   mix deps.get
   mix compile
   ```

3. Setup the database

   ```bash
   mix ecto.setup
   ```

4. Install Node.js dependencies

   ```bash
   cd assets
   npm install
   cd ..
   ```

5. Start the Phoenix server

   ```bash
   mix phx.server
   ```

6. Visit [`localhost:4000`](http://localhost:4000) in your browser

### Docker Deployment

Alternatively, you can use Docker for development or production:

```bash
docker-compose up -d
```

## Usage

1. Create an account on the homepage
2. Log in to your dashboard
3. Add websites you want to monitor with their name and URL
4. View the status and previews of your websites in real-time
5. Toggle between live iframe previews and thumbnails as needed

## Current Development Status

Check the project's current status:

- [x] Use iframes whenever possible to avoid overhead
- [x] Make sure thumbnails are small
- [x] Limit iframes to 32 per free account
- [x] Limit thumbnails to 4 per free account
- [x] User deletion
- [x] Add github link to page
- [x] Add landing page
- [x] Implement automatic refresh
- [x] Fix timer on mobile view
- [x] Show unavailable websites as offline & red
- [x] Redirect "users/register" to "/"
- [x] Add fk to websites -> users
- [x] Fix /users/settings layout
- [x] Link back to "/" on header icon and title
- [x] Implement privacy policy
- [x] Implement terms of service
- [x] Improve thumbnail update process
- [x] Fix "Signup Password can't be blank" message
- [x] Allow inputs without http or with www
- [x] Make sign-up process nicer
- [x] Improve SEO
- [ ] Implement edit website
- [ ] Take redirects into account
- [ ] Fix tests
