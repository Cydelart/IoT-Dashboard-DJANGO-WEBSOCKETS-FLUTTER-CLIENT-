"""
Django settings for iot_backend project.
"""

from pathlib import Path

# -------------------------------
# Base directory
# -------------------------------
BASE_DIR = Path(__file__).resolve().parent.parent

# -------------------------------
# Security
# -------------------------------
SECRET_KEY = 'django-insecure-p(*r9p9x#=h%u)_!^@1ec5)cq_2%3_n(1dgci=)y1a626#(mv8'
DEBUG = True
ALLOWED_HOSTS = []

# -------------------------------
# InfluxDB settings
# -------------------------------
INFLUXDB = {
    "url": "http://localhost:8086",
    "token": "ecbAixQd-7qFL33PEuo82FbgLEXtBuVB1jnGILFjUlruOlF7EUJl45KU1z3gsNsITGSfp1CnxRoSt9nXkWDdWQ==",
    "org": "ISG",
    "bucket": "telemetry",
}

# -------------------------------
# ASGI + Channels
# -------------------------------
ASGI_APPLICATION = "iot_backend.asgi.application"

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
    },
}

# -------------------------------
# Installed apps
# -------------------------------
INSTALLED_APPS = [
    'daphne',  # optional if you want daphne server
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'corsheaders',
    'rest_framework',
    'channels',
<<<<<<< HEAD
    'api',
]
#maintenir websocket ouvert
ASGI_APPLICATION = "iot_backend.asgi.application"
=======
    'rest_framework_simplejwt',  # <-- ajouté
    'api',  # ton app principale
]

# -------------------------------
# Middleware
# -------------------------------
>>>>>>> b8df76b (final version)
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

<<<<<<< HEAD
=======
# -------------------------------
# URL configuration
# -------------------------------
>>>>>>> b8df76b (final version)
ROOT_URLCONF = 'iot_backend.urls'

# -------------------------------
# Templates
# -------------------------------
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# -------------------------------
# WSGI application
# -------------------------------
WSGI_APPLICATION = 'iot_backend.wsgi.application'
<<<<<<< HEAD

#definir la couche de communication
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
    },
}

=======
>>>>>>> b8df76b (final version)

# -------------------------------
# Database
# -------------------------------
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
    
}

<<<<<<< HEAD


=======
# -------------------------------
>>>>>>> b8df76b (final version)
# Password validation
# -------------------------------
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}

# -------------------------------
# Internationalization
# -------------------------------
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# -------------------------------
# Static files
# -------------------------------
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# -------------------------------
# Default primary key
# -------------------------------
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
<<<<<<< HEAD
CORS_ALLOW_ALL_ORIGINS = True
=======

# -------------------------------
# CORS
# -------------------------------
CORS_ALLOW_ALL_ORIGINS = True

from datetime import timedelta

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),  # access token valable 30 min
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),     # refresh token 1 jour
    'AUTH_HEADER_TYPES': ('Bearer',),
}

>>>>>>> b8df76b (final version)
