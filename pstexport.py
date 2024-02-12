import os
from pypff import open as pff_open

def extract_pdfs_from_pst(pst_file, output_dir):
    # Open the PST file
    pst = pff_open(pst_file)
    root = pst.get_root_folder()

    def process_message(message):
        for attachment in message.attachments:
            if attachment.name.lower().endswith('.pdf'):
                file_path = os.path.join(output_dir, attachment.name)
                with open(file_path, 'wb') as file:
                    file.write(attachment.read_buffer())
                print(f"Extracted: {file_path}")

    def process_folder(folder):
        # Process all messages in the folder
        for message in folder.sub_messages:
            process_message(message)

        # Recursively process subfolders
        for sub_folder in folder.sub_folders:
            process_folder(sub_folder)

    process_folder(root)

# Example usage
pst_file_path = r'C:\alexwexport\backup.pst'
output_directory = r'C:\alexwexport\exp'
extract_pdfs_from_pst(pst_file_path, output_directory)
