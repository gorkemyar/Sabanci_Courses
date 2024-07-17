import uuid
import os
from core.config import settings


class ImageUtilities:
    def is_valid_image(file):
        pass

    @staticmethod
    def change_image_name(image):
        filename = image.filename.split(".")
        new_filename = str(uuid.uuid4()) + "." + filename[1]
        return new_filename

    @staticmethod
    def save_image(image, *argv):
        folder_directory = [settings.MEDIA_FOLDER]
        folder_directory.extend(argv)
        folder_directory.append(ImageUtilities.change_image_name(image))

        path = "/".join(folder_directory)
        db_path = "/".join(folder_directory[1:])

        with open(path, "wb+") as f:
            f.write(image.file.read())
            f.close()
        return db_path

    @staticmethod
    def get_image_url(path):
        return "/".join([settings.BASE_URL, settings.MEDIA_FOLDER, path])

    @staticmethod
    def get_image_dir(path):
        return "/".join([settings.MEDIA_FOLDER, path])

    @staticmethod
    def remove_image(path):
        image_dir = ImageUtilities.get_image_dir(path)
        if os.path.exists(image_dir):
            os.remove(image_dir)
