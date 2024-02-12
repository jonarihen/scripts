import pypff

def get_pst_info(pst_file_path):
    try:
        # Open the PST file
        pst = pypff.open(pst_file_path)
        root = pst.get_root_folder()

        # Initialize count
        total_messages = 0

        # Function to recursively count messages in each folder
        def count_messages(folder):
            nonlocal total_messages
            total_messages += folder.number_of_sub_messages
            for sub_folder in folder.sub_folders:
                count_messages(sub_folder)

        # Start counting from the root folder
        count_messages(root)

        # Close the PST file
        pst.close()

        return total_messages

    except Exception as e:
        return str(e)

# Specify the PST file path
pst_file_path = r'C:\alexwexport\backup.pst'

# Get the total number of messages in the PST file
total_messages = get_pst_info(pst_file_path)
print(f'Total number of messages in the PST file: {total_messages}')
