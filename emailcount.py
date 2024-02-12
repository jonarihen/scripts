import pypff

# Function to get basic info from the PST file
def get_pst_info(pst_file_path):
    # Attempt to open the PST file
    try:
        pst = pypff.open(pst_file_path)
        root = pst.get_root_folder()
        # Get some basic info
        info = {
            'Number of Folders': root.number_of_sub_folders,
            'Number of Messages': root.number_of_sub_messages
        }
        return info
    except Exception as e:
        return str(e)

# Path to the PST file
pst_file_path = r'C:\alexwexport\backup.pst'

# Call the function and print the results
pst_info = get_pst_info(pst_file_path)
pst_info
