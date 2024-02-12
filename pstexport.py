import os
from pypff import open as pff_open

# Set the PST file path and the output directory at the top of the script
pst_file = r'C:\alexwexport\backup.pst'
output_dir = r'C:\alexwexport\exp'

def extract_pdfs_from_pst(pst_file, output_dir):
    # Open the PST file
    pst = pff_open(pst_file)
    root = pst.get_root_folder()

    def process_folder(folder):
        # Process all messages in the folder
        for message in folder.sub_messages:
            for attachment in message.attachments:
                if attachment.name.lower().endswith('.pdf'):
                    # Create the output directory if it doesn't exist
                    os.makedirs(output_dir, exist_ok=True)
                    file_path = os.path.join(output_dir, attachment.name)
                    with open(file_path, 'wb') as file:
                        file.write(attachment.read_buffer())
                    print(f"Extracted: {file_path}")

        # Recursively process subfolders
        for sub_folder in folder.sub_folders:
            process_folder(sub_folder)

    process_folder(root)

# Call the function with the specified paths
extract_pdfs_from_pst(pst_file, output_dir)
