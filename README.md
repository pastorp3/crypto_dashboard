
## Setup Instructions

### Prerequisites
- Ruby "3.1.2"
- Rails "7.0.8"

### Getting Started

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/your-username/weather-api.git](https://github.com/pastorp3/crypto_dashboard.git)

2. **Install Dependencies:**
   ```bash
   bundle install
   yarn install

2. **Setup Database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   
3. **Add your api key:**

   open app/services/fetch_coin_value.rb in your local and add your key  after ApiKey=

5. **Start the Rails Server:**
   ```bash
   rails server

6. **Open App in your local server:**
   ```bash
   http://localhost:3000

