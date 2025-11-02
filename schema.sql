-- ===========================================
-- Recipe Database Schema
-- ===========================================

-- Drop all tables
DROP TABLE IF EXISTS ratings, recipe_tags, recipe_ingredients, images, tags, ingredients, measurements, recipes, users CASCADE;

-- ---------------------------
-- Users
-- ---------------------------
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(150),
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ---------------------------
-- Recipes
-- ---------------------------
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructions TEXT,
    prep_time_minutes INTEGER,
    cook_time_minutes INTEGER,
    servings INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    average_rating NUMERIC(2,1) DEFAULT 0.0
);

-- ---------------------------
-- Ingredients
-- ---------------------------
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) UNIQUE NOT NULL
);

-- ---------------------------
-- Measurements
-- ---------------------------
CREATE TABLE measurements (
    id SERIAL PRIMARY KEY,
    unit_name VARCHAR(50) UNIQUE NOT NULL,
    abbreviation VARCHAR(10)
);

-- ---------------------------
-- Recipe ↔ Ingredients
-- ---------------------------
CREATE TABLE recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id),
    measurement_id INTEGER REFERENCES measurements(id),
    amount NUMERIC(10,2),
    note TEXT
);

-- ---------------------------
-- Tags
-- ---------------------------
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- ---------------------------
-- Recipe ↔ Tags
-- ---------------------------
CREATE TABLE recipe_tags (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE
);

-- ---------------------------
-- Ratings
-- ---------------------------
CREATE TABLE ratings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    rating SMALLINT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (user_id, recipe_id)
);

-- ---------------------------
-- Images
-- ---------------------------
CREATE TABLE images (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    caption TEXT
);

-- ---------------------------
-- Preload common tags
-- ---------------------------
INSERT INTO tags (name)
VALUES
    ('breakfast'),
    ('lunch'),
    ('dinner'),
    ('big meal'),
    ('small meal'),
    ('dessert'),
    ('instant pot'),
    ('baked'),
    ('cast iron'),
    ('quick')
ON CONFLICT DO NOTHING;

-- ---------------------------
-- Triggers
-- ---------------------------
-- Update average_rating on recipes when a rating is added or updated
CREATE OR REPLACE FUNCTION update_average_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE recipes
    SET average_rating = (
        SELECT ROUND(AVG(rating)::numeric, 1)
        FROM ratings
        WHERE recipe_id = NEW.recipe_id
    )
    WHERE id = NEW.recipe_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_average_rating
AFTER INSERT OR UPDATE OR DELETE ON ratings
FOR EACH ROW
EXECUTE FUNCTION update_average_rating();
