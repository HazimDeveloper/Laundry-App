const crypto = require("crypto");
const twilio = require("twilio");
require('dotenv').config();

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;

if (!accountSid || !authToken) {
    console.error("Twilio credentials are missing. Please check your .env file.");
    process.exit(1);
}

const twilioClient = new twilio(accountSid, authToken);

const otpStorage = new Map();

const otpController = {
    sendOtp: async (req, res) => {
        try {
            const { phoneNumber } = req.body;

            if (!phoneNumber) {
                return res.status(400).json({ error: "Phone number is required" });
            }

            const otp = crypto.randomInt(100000, 999999).toString();

            otpStorage.set(phoneNumber, otp);

            await twilioClient.messages.create({
                body: `Your OTP is ${otp}`,
                from: twilioPhoneNumber,
                to: phoneNumber
            });

            res.json({ message: "OTP sent successfully" });
        } catch (error) {
            console.error("Error sending OTP:", error);
            res.status(500).json({ error: "An error occurred while sending OTP" });
        }
    },

    verifyOtp: async (req, res) => {
        try {
            const { phoneNumber, otp } = req.body;

            if (!phoneNumber || !otp) {
                return res.status(400).json({ error: "Phone number and OTP are required" });
            }

            const storedOtp = otpStorage.get(phoneNumber);

            let isValid = false;

            if (storedOtp && storedOtp === otp) {
                isValid = true;
                otpStorage.delete(phoneNumber);
            }

            res.json({
                isValid: isValid,
                message: isValid ? "OTP verified successfully" : "Invalid OTP"
            });
        } catch (error) {
            console.error("Error verifying OTP:", error);
            res.status(500).json({ error: "An error occurred while verifying OTP" });
        }
    }
};

module.exports = otpController;