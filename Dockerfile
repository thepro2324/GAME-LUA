# משתמשים בגרסה קלה של לינוקס
FROM alpine:latest

# מתקינים Lua ואת ספריית ה-Socket
RUN apk add --no-cache \
    lua5.3 \
    lua-socket

# מעתיקים את הקבצים שלנו לתוך השרת
COPY . /app
WORKDIR /app

# פקודת ההרצה
CMD ["lua5.3", "server.lua"]
