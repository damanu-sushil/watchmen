import cv2
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import os
from time import sleep
from dotenv import load_dotenv
env = load_dotenv()

# Compile-time type declaration
def capture_image() -> str:
    cam = cv2.VideoCapture(0)  # Open the webcam
    ret, frame = cam.read()    # Read a frame
    if ret:
        img_name = "intruder.png"
        cv2.imwrite(img_name, frame)
    cam.release()              # Release the webcam
    return img_name

def send_email(str image_path):
    sender_email = "sushilkumardora1290@gmail.com"
    receiver_email = "dskd1290@gmail.com"
    password = os.getenv('EMAIL_PASS')

    message = MIMEMultipart()
    message['From'] = sender_email
    message['To'] = receiver_email
    message['Subject'] = "Intruder Alert!"

    with open(image_path, "rb") as attachment:
        part = MIMEBase("application", "octet-stream")
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header("Content-Disposition", f"attachment; filename= {image_path}")
        message.attach(part)

    smtp_server = 'smtp.gmail.com'
    smtp_port = 465
    with smtplib.SMTP_SSL(smtp_server, smtp_port) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())

def main():
    sleep(5)  # Optional: Wait a few seconds before capturing
    image_path = capture_image()
    send_email(image_path)
    os.remove(image_path)  # Remove the image file after sending

if __name__ == "__main__":
    main()
