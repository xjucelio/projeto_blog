
from django.urls import path  # type: ignore
from blog.views import index, page, post  # type: ignore


app_name = 'blog'

urlpatterns = [
    path('', index, name='index'),
    path('post/<slug:slug>/', post, name='post'),
    path('page/', page, name='page'),
]
