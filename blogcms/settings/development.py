from .base import *

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": ("knox.auth.TokenAuthentication",),
}

USE_SPACES = config("USE_SPACES", default=False, cast=bool)
print(USE_SPACES, " my use spaces configurations")
if USE_SPACES != False:
    # settings
    AWS_ACCESS_KEY_ID = config("AWS_ACCESS_KEY_ID")
    AWS_SECRET_ACCESS_KEY = config("AWS_SECRET_ACCESS_KEY")
    AWS_STORAGE_BUCKET_NAME = config("AWS_STORAGE_BUCKET_NAME")
    AWS_DEFAULT_ACL = config("AWS_DEFAULT_ACL")
    AWS_S3_ENDPOINT_URL = f"https://{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com"
    # config("AWS_S3_ENDPOINT_URL")
    AWS_S3_OBJECT_PARAMETERS = {"CacheControl": "max-age=86400"}
    AWS_LOCATION = config("AWS_LOCATION")
    STATIC_URL = f"https://{AWS_S3_ENDPOINT_URL}/{AWS_LOCATION}/"
    STATICFILES_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"
    AWS_S3_SIGNATURE_VERSION = "s3v4"
    # DEFAULT_FILE_STORAGE='storages.backends.s3boto3.S3Boto3Storage'
else:
    STATIC_URL = "/staticfiles/"
    STATIC_ROOT = BASE_DIR / "staticfiles"
    STATICFILES_DIR = []
    MEDIA_URL = "/mediafiles/"
    MEDIA_ROOT = BASE_DIR / "mediafiles"
