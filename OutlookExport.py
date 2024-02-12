from exchangelib import Credentials, Account, Configuration, FileAttachment, DELEGATE

# Define your Exchange Online credentials
credentials = Credentials('alexw@w4ns.com', 'newRoper3349')

# Define the configuration with your server details
config = Configuration(server='outlook.office365.com', credentials=credentials)

# Create an account object with the configuration
account = Account('alexw@w4ns.com', config=config, autodiscover=False, access_type=DELEGATE)

# Define the directory where attachments will be saved
save_path = 'C:/alexwexport/'

def save_attachment(message, attachment):
    # Create the folder path based on the folder hierarchy in Outlook
    local_path = os.path.join(save_path, message.folder.folder_path)
    # Replace invalid characters for folder names if necessary here
    os.makedirs(local_path, exist_ok=True)
    
    local_file_path = os.path.join(local_path, attachment.name)
    with open(local_file_path, 'wb') as f:
        f.write(attachment.content)
    print(f"Attachment {attachment.name} saved in {local_path}")

# Function to process a single folder
def process_folder(folder):
    # Get all items in the folder that have attachments
    items = folder.all().filter(has_attachments=True)
    
    # Loop through each item
    for item in items:
        # Loop through each attachment
        for attachment in item.attachments:
            # Check if the attachment is a PDF and is a file (not an item attachment)
            if isinstance(attachment, FileAttachment) and attachment.name.lower().endswith('.pdf'):
                save_attachment(item, attachment)

# Specify the folder to process first
specific_folder = account.inbox # Or use account.root / 'path' / 'to' / 'folder' for custom folders
process_folder(specific_folder)

# Then process all other folders
for folder in account.root.walk():
    if folder == specific_folder:
        continue  # Skip the folder if it's the one we've already processed
    process_folder(folder)

print("All attachments have been downloaded.")
