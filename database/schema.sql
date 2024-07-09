CREATE TABLE languages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    code VARCHAR(10) UNIQUE
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE dictionaries (
    id SERIAL PRIMARY KEY,
    lang_id INTEGER,
    definition TEXT NULL,
    word VARCHAR(100),
    transcription VARCHAR(100),
    UNIQUE (lang_id, word),
    FOREIGN KEY (lang_id) REFERENCES languages(id)
);

CREATE TABLE translations (
    translation_id SERIAL PRIMARY KEY,
    source_lang_id INTEGER,
    target_lang_id INTEGER,
    source_word INTEGER,
    target_word INTEGER,
    FOREIGN KEY (source_lang_id) REFERENCES languages(id),
    FOREIGN KEY (target_lang_id) REFERENCES languages(id),
    FOREIGN KEY (source_word) REFERENCES dictionaries(id),
    FOREIGN KEY (target_word) REFERENCES dictionaries(id)
);

CREATE TABLE user_dictionaries (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    custom_definition TEXT NULL,
    created_at TIMESTAMP DEFAULT current_timestamp,
    translation INTEGER,
    custom_translation VARCHAR(100) NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (translation) REFERENCES translations(translation_id)
);

CREATE TABLE flashcards (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT current_timestamp,
    content INTEGER,
    FOREIGN KEY (content) REFERENCES user_dictionaries(id)
);

CREATE TABLE user_progress (
    id SERIAL PRIMARY KEY,
    ease_factor FLOAT DEFAULT 2.5,
    interval INTEGER DEFAULT 0,
    next_review_date DATE,
    review_count INTEGER DEFAULT 0,
    last_reviewed_at TIMESTAMP,
    user_id INTEGER UNIQUE,
    flashcard_id INTEGER UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (flashcard_id) REFERENCES flashcards(id)
);

CREATE INDEX idx_user_dictionaries_user_id ON user_dictionaries(user_id);
CREATE INDEX idx_flashcards_content ON flashcards(content);
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_next_review_date ON user_progress(next_review_date);