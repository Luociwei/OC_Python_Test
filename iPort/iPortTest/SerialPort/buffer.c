//
//  Buffer.c
//  PhHost
//
//  Created by Dustin M DeWeese on 3/28/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#include "buffer.h"
#include "unistd.h"

void buffer_init(struct buffer *b) {
    b->head = b->tail = 0;
}

bool buffer_push(struct buffer *b, char x) {
    if((b->head - b->tail & BUFFER_MASK) == 1) return false;
    b->data[b->head++] = x;
    b->head &= BUFFER_MASK;
    return true;
}

int buffer_pop(struct buffer *b) {
    if(b->head == b->tail) return -1;
    char x = b->data[b->tail++];
    b->tail &= BUFFER_MASK;
    return x;
}
/*
ssize_t buffer_move(struct buffer *b, char *dst, ssize_t size)
{
    ssize_t remaining = size, available = buffer_fill(b);
    if (remaining > available) {
        remaining = available;
    }
    if (b->head == b->tail) return 0;
    if (b->head + remaining < BUFFER_SIZE) {
        memcpy(dst, &b->data[head], remaining);
        b->head += remaining;
    } else {
        ssize_t first_copy = BUFFER_SIZE - remaining;
        memcpy(dst, &b->data[head], first_copy);
        dst += first_copy;
        remaining -= first_copy;
        memcpy(dst, &b->data[0], remaining);
        b->head = remaining;
    }
}
*/
int buffer_fill(struct buffer *b) {
    return b->head - b->tail & BUFFER_MASK;
}

int buffer_read(struct buffer *b, int fd) {
    ssize_t bytes_to_read = (b->tail > b->head ? b->tail - 1 : (b->tail ? BUFFER_SIZE : BUFFER_SIZE - 1)) - b->head;
    ssize_t bytes = read(fd, &b->data[b->head], bytes_to_read);
    if (bytes > 0) {
        b->head = b->head + bytes & BUFFER_MASK;
    }
    return (int)bytes;
}

bool buffer_match(struct buffer *b, const char *pattern) {
    unsigned int i = b->tail;
    while (*pattern) {
        if (i == b->head) {
            return false;
        }
        if (*pattern == b->data[i]) {
           pattern++;
           i = i + 1 & BUFFER_MASK;
        } else {
           return false;
        }
    }
    return true;
}
