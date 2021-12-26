//
//  buffer.h
//  PhHost
//
//  Created by Dustin M DeWeese on 3/28/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#ifndef PhHost_buffer_h
#define PhHost_buffer_h

#include "stdbool.h"

// this must be a power of 2
#define BUFFER_SIZE (1<<10)
#define BUFFER_MASK (BUFFER_SIZE - 1)

struct buffer {
    char data[BUFFER_SIZE];
    unsigned int head, tail;
};

void buffer_init(struct buffer *b);
bool buffer_push(struct buffer *b, char x);
int buffer_pop(struct buffer *b);
int buffer_fill(struct buffer *b);
int buffer_read(struct buffer *b, int fd);
bool buffer_match(struct buffer *b, const char *pattern);

#endif
