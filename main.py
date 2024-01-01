from auth0_component import login_button
import streamlit as st
from gradio_client import Client
from PIL import Image
import shutil
import tempfile
import os

# Initialize Gradio client
GRADIO_API_URL = "https://jjourney1125-swin2sr.hf.space/"
client = Client(GRADIO_API_URL)

# Function to handle image prediction and saving
def predict_and_show_image(uploaded_file):
    with st.spinner('🤖 AI is enhancing your image...'):
        # Save the uploaded image to a temporary file
        temp_image = tempfile.NamedTemporaryFile(delete=False)
        temp_image.write(uploaded_file.getvalue())
        temp_image.close()
        
        # Use Gradio client to predict
        result = client.predict(temp_image.name, api_name="/predict")
        
        # Copy the result to a new file
        output_image_path = 'output_image.png'
        shutil.copy(result, output_image_path)

        # Show the enhanced image (after)
        new_image = Image.open(output_image_path)
        st.image(new_image, caption='🌟 Enhanced Image', use_column_width=True)
        
        # Clean up temporary files
        os.remove(temp_image.name)
        os.remove(output_image_path)

# Get the clientId and domain from environment variables
clientId = os.getenv("CLIENT_ID")
domain = os.getenv("DOMAIN")
user_info = login_button(clientId, domain=domain)

# Check if user is logged in
if True:
    st.title('🎓 Restorify: Bringing Old Text Back to Life with AI')

    # Display thematic text on sustainability
    st.markdown('♻️ Contribute to **sustainability** by restoring historical texts and reducing paper waste.')

    # File uploader
    uploaded_file = st.file_uploader("📤 Drag and drop or click to upload your image", type=["png", "jpg", "jpeg"])
    st.caption('Supported formats: png, jpg, jpeg')

    if uploaded_file:
        # Show the uploaded image (before)
        image = Image.open(uploaded_file)
        st.image(image, caption='📝 Uploaded Image', use_column_width=True)

        # Display thematic text on accessibility
        st.markdown('🔍 Increase **accessibility** by making old texts readable for everyone.')

        # Submit button
        if st.button('✨ Enhance Image'):
            # Call function to predict and show image
            predict_and_show_image(uploaded_file)

    # Additional thematic texts can be added here as needed
    st.markdown('📚 Utilize AI to unlock the knowledge from the past, aiding in **education** and preserving history.')
    st.markdown('🌐 Promoting **equality** by making information accessible to all.')

else:
    st.markdown('🔐 Please log in to use the application.')