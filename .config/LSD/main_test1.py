# # import numpy as np
# #
# #
# # # MSB Prediction using Vectorized Operations
# # def msb_prediction(image):
# #     left = np.roll(image, 1, axis=1)  # Shift left
# #     top = np.roll(image, 1, axis=0)  # Shift up
# #     top_left = np.roll(np.roll(image, 1, axis=0), 1, axis=1)  # Shift diagonally
# #
# #     # Apply weights to neighbors for prediction (simple average here)
# #     predicted_image = left * 0.33 + top * 0.33 + top_left * 0.33
# #
# #     # Clip values to keep them in valid pixel range
# #     predicted_image = np.clip(predicted_image, 0, 255)
# #
# #     return predicted_image.astype(np.uint8)
# #
# #
# # # Matrix Encoding for MSB Data Embedding
# # def matrix_encoding(block, data_bits):
# #     parity_matrix = np.array([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
# #     block = block[:3]  # Work with first 3 bits
# #
# #     syndrome = np.dot(block, parity_matrix.T) % 2
# #
# #     if np.array_equal(syndrome, data_bits):
# #         return block
# #     else:
# #         for i in range(len(block)):
# #             modified_block = np.copy(block)
# #             modified_block[i] = 1 - block[i]  # Flip bit
# #             if np.array_equal(np.dot(modified_block, parity_matrix.T) % 2, data_bits):
# #                 return modified_block
# #     return block
# #
# #
# # # Embed Data Using MSB Prediction and Matrix Encoding
# # def embed_data_msb(image, secret_data):
# #     if isinstance(secret_data, str):
# #         secret_data = secret_data.encode("utf-8")
# #
# #     data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
# #     data_bits = np.unpackbits(data_bytes)
# #
# #     flat_image = image.flatten()
# #     idx = 0
# #
# #     for i in range(0, len(flat_image), 1):
# #         block = np.unpackbits(np.array([flat_image[i]], dtype=np.uint8))[:3]
# #
# #         if idx + 3 <= len(data_bits):
# #             encoded_block = matrix_encoding(block, data_bits[idx : idx + 3])
# #             packed_block = np.packbits(np.pad(encoded_block, (0, 5), constant_values=0))
# #             flat_image[i] = packed_block[0]
# #             idx += 3
# #
# #     return flat_image.reshape(image.shape)
# #
# #
# # def histogram_shift(image_channel, data_bits):
# #     # Get the histogram of pixel values
# #     hist, bins = np.histogram(image_channel.flatten(), bins=256, range=(0, 255))
# #
# #     # Find zero/minimum point for shifting
# #     min_bin = np.argmin(hist)
# #
# #     shifted_channel = np.copy(image_channel)
# #     idx = 0
# #
# #     for i in range(shifted_channel.shape[0]):
# #         for j in range(shifted_channel.shape[1]):
# #             pixel = shifted_channel[i, j]
# #             if idx < len(data_bits) and (pixel == min_bin or pixel == min_bin + 1):
# #                 if data_bits[idx] == 1:
# #                     shifted_channel[i, j] += 1  # Shift pixel to embed data
# #                 idx += 1
# #
# #     return shifted_channel
# #
# #
# # def embed_data_histogram(image, secret_data):
# #     if isinstance(secret_data, str):
# #         secret_data = secret_data.encode("utf-8")
# #
# #     data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
# #     data_bits = np.unpackbits(data_bytes)
# #
# #     for channel in range(3):
# #         channel_data = image[:, :, channel].flatten()
# #         image[:, :, channel] = histogram_shift(
# #             channel_data.reshape(image[:, :, channel].shape), data_bits
# #         )
# #
# #     return image
# #
# #
# # from PIL import Image
# #
# # # Load image
# # image = np.array(Image.open("./fairycore-misty-forest-desktop-wallpaper.png"))
# #
# # # Secret data to hide
# # secret_data = "Hello World"
# #
# # # Step 1: First Layer (MSB Prediction + Matrix Encoding)
# # encoded_image = embed_data_msb(image, secret_data)
# #
# # # Step 2: Second Layer (Histogram Shifting)
# # encoded_image = embed_data_histogram(encoded_image, secret_data)
# #
# # # Save the encoded image
# # encoded_img_pil = Image.fromarray(encoded_image)
# # encoded_img_pil.save("encoded_image.png")
# #
# # # Decoding would follow a similar process in reverse:
# # # Step 1: Extract data from histogram shifted part
# # # Step 2: Reverse matrix encoding and MSB prediction
#
# import numpy as np
#
#
# # MSB Prediction using Vectorized Operations
# def msb_prediction(image):
#     left = np.roll(image, 1, axis=1)  # Shift left
#     top = np.roll(image, 1, axis=0)  # Shift up
#     top_left = np.roll(np.roll(image, 1, axis=0), 1, axis=1)  # Shift diagonally
#
#     # Apply weights to neighbors for prediction (simple average here)
#     predicted_image = left * 0.33 + top * 0.33 + top_left * 0.33
#
#     # Clip values to keep them in valid pixel range
#     predicted_image = np.clip(predicted_image, 0, 255)
#
#     return predicted_image.astype(np.uint8)
#
#
# # Matrix Encoding for MSB Data Embedding
# def matrix_encoding(block, data_bits):
#     parity_matrix = np.array([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
#     block = block[:3]  # Work with first 3 bits
#
#     syndrome = np.dot(block, parity_matrix.T) % 2
#
#     if np.array_equal(syndrome, data_bits):
#         return block
#     else:
#         for i in range(len(block)):
#             modified_block = np.copy(block)
#             modified_block[i] = 1 - block[i]  # Flip bit
#             if np.array_equal(np.dot(modified_block, parity_matrix.T) % 2, data_bits):
#                 return modified_block
#     return block
#
#
# # Embed Data Using MSB Prediction and Matrix Encoding
# def embed_data_msb(image, secret_data):
#     if isinstance(secret_data, str):
#         secret_data = secret_data.encode("utf-8")
#
#     data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
#     data_bits = np.unpackbits(data_bytes)
#
#     flat_image = image.flatten()
#     idx = 0
#
#     for i in range(0, len(flat_image), 1):
#         block = np.unpackbits(np.array([flat_image[i]], dtype=np.uint8))[:3]
#
#         if idx + 3 <= len(data_bits):
#             encoded_block = matrix_encoding(block, data_bits[idx : idx + 3])
#             packed_block = np.packbits(np.pad(encoded_block, (0, 5), constant_values=0))
#             flat_image[i] = packed_block[0]
#             idx += 3
#
#     return flat_image.reshape(image.shape)
#
#
# # Reverse Matrix Encoding and MSB Prediction for Decoding
# def decode_data_msb(image, data_length):
#     flat_image = image.flatten()
#     data_bits = []
#
#     for i in range(0, data_length // 3):  # Since we embed 3 bits per pixel
#         block = np.unpackbits(np.array([flat_image[i]], dtype=np.uint8))[:3]
#         data_bits.extend(block)  # Extract the 3 bits from the block
#
#     # Pack the extracted bits back into bytes and convert to the original secret data
#     secret_data_bytes = np.packbits(data_bits[:data_length])
#     secret_data = secret_data_bytes.tobytes().decode("utf-8", errors="ignore")
#
#     return secret_data
#
#
# def histogram_shift(image_channel, data_bits):
#     hist, bins = np.histogram(image_channel.flatten(), bins=256, range=(0, 255))
#     min_bin = np.argmin(hist)
#
#     shifted_channel = np.copy(image_channel)
#     idx = 0
#
#     for i in range(shifted_channel.shape[0]):
#         for j in range(shifted_channel.shape[1]):
#             pixel = shifted_channel[i, j]
#             if idx < len(data_bits) and (pixel == min_bin or pixel == min_bin + 1):
#                 if data_bits[idx] == 1:
#                     shifted_channel[i, j] += 1  # Shift pixel to embed data
#                 idx += 1
#
#     return shifted_channel
#
#
# # Embed Data Using Histogram Shifting
# def embed_data_histogram(image, secret_data):
#     if isinstance(secret_data, str):
#         secret_data = secret_data.encode("utf-8")
#
#     data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
#     data_bits = np.unpackbits(data_bytes)
#
#     for channel in range(3):
#         channel_data = image[:, :, channel].flatten()
#         image[:, :, channel] = histogram_shift(
#             channel_data.reshape(image[:, :, channel].shape), data_bits
#         )
#
#     return image
#
#
# # Reverse Histogram Shifting for Decoding
# def reverse_histogram_shift(encoded_channel, data_length):
#     # Extract LSB-embedded bits
#     extracted_bits = []
#
#     flat_channel = encoded_channel.flatten()
#
#     for i in range(data_length):
#         extracted_bits.append(flat_channel[i] & 1)  # Extract LSB
#
#     # Convert extracted bits back to bytes
#     extracted_bytes = np.packbits(extracted_bits)
#     extracted_data = extracted_bytes.tobytes().decode("utf-8", errors="ignore")
#
#     return extracted_data
#
#
# # Restore original image by reversing the histogram shifts
# def restore_original_image(image):
#     return image  # Since this example uses LSB-based changes, no additional change is required
#
#
# from PIL import Image
#
# # Load image
# image = np.array(Image.open("./fairycore-misty-forest-desktop-wallpaper.png"))
#
# # Secret data to hide
# secret_data = "Nigger man..."
#
# # Step 1: First Layer (MSB Prediction + Matrix Encoding)
# encoded_image = embed_data_msb(image, secret_data)
#
# # Step 2: Second Layer (Histogram Shifting)
# encoded_image = embed_data_histogram(encoded_image, secret_data)
#
# # Save the encoded image
# encoded_img_pil = Image.fromarray(encoded_image)
# encoded_img_pil.save("encoded_image.png")
#
# # Decoding Steps
#
# # Step 1: Reverse Histogram Shifting to extract part of the data
# data_length = len(secret_data) * 8  # Each character is 8 bits
# extracted_data = reverse_histogram_shift(
#     encoded_image[:, :, 0], data_length
# )  # From first channel
#
# # Step 2: Reverse MSB prediction and matrix encoding to extract remaining data
# remaining_secret_data = decode_data_msb(encoded_image, data_length)
#
# # Restore original image
# restored_image = restore_original_image(encoded_image)
#
# # Save the restored original image
# restored_img_pil = Image.fromarray(restored_image)
# restored_img_pil.save("restored_image.png")
#
# # Verify if the decoded data matches the original
# print("Extracted data from histogram:", extracted_data)
# print("Remaining secret data from MSB:", remaining_secret_data)

with open("./fairycore-misty-forest-desktop-wallpaper.png") as file:
    print(file.read())
    print()
