# Automated YouTube Channel Program Installation Guide

This guide will walk you through the installation process for setting up an automated YouTube channel program using Ruby programming language.

## Prerequisites

Before you begin, ensure you have the following prerequisites installed on your system:

- Ruby: Make sure you have Ruby installed. You can download it from [here](https://www.ruby-lang.org/en/downloads/).

## Installation Steps

1. **Clone the Repository:**
   Clone the repository containing the automated YouTube channel program source code to your local machine.

   ```bash
   git clone https://github.com/munsterkreations/automation
   ```

2. **Navigate to the Project Directory:**
   Change your current directory to the cloned project directory.

   ```bash
   cd automation
   ```

3. **Install Dependencies:**
   Install the required Ruby dependencies using Bundler.

   ```bash
   bundle install
   ```

4. **Set Up YouTube API Credentials:**
   Obtain API credentials from the Google Cloud Console for the YouTube Data API v3. Save the credentials file (`client_secret.json`) in the project directory.

5. **Configure Settings:**
   Edit the configuration file (`config.yml`) to customize settings such as video title format, upload frequency, etc., according to your preferences.

6. **Run the Program:**
   Execute the Ruby script to start the automated YouTube channel program.

   ```bash
   ruby main.rb
   ```

7. **Authorization:**
   Follow the on-screen prompts to authorize the program to access your YouTube account. This is necessary for uploading videos.

8. **Enjoy Automation:**
   Sit back and let the program handle the creation and uploading of content to your YouTube channel automatically!

## Additional Notes

- Make sure to keep your API credentials (`client_secret.json`) secure and do not expose them publicly.
- Regularly check the logs generated by the program for any errors or notifications.


## adjustments and request 
Feel free to customize the instructions and add more details specific to your program.
