import { Client, GatewayIntentBits } from 'discord.js';
import dotenv from 'dotenv';
dotenv.config(); // Load environment variables from .env file

const client = new Client({ intents: [GatewayIntentBits.Guilds] });

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
});

const token = process.env.TOKEN;
if (!token) {
    console.error('TOKEN environment variable is not set.');
    process.exit(1);
}
client.login(token);