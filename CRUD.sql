-- CREATE --
INSERT INTO recipes (author_id, title, description, instructions, prep_time_minutes, cook_time_minutes, servings)
VALUES (
  (SELECT id FROM users WHERE username = 'chef_anna'),
  'Creamy Garlic Chicken',
  'Tender chicken in a creamy garlic sauce.',
  'Brown chicken, add cream and garlic, simmer for 20 minutes.',
  10, 30, 4
)
RETURNING id;

INSERT INTO ingredients (name)
VALUES ('chicken breast'), ('garlic cloves'), ('heavy cream')
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount, note)
VALUES
  (8, (SELECT id FROM ingredients WHERE name='chicken breast'), (SELECT id FROM measurements WHERE unit_name='pound'), 1.5, NULL),
  (8, (SELECT id FROM ingredients WHERE name='garlic cloves'), (SELECT id FROM measurements WHERE unit_name='clove'), 3, NULL),
  (8, (SELECT id FROM ingredients WHERE name='heavy cream'), (SELECT id FROM measurements WHERE unit_name='cup'), 1, NULL);

INSERT INTO tags (name)
VALUES ('chicken'), ('creamy'), ('quick')
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_tags (recipe_id, tag_id)
SELECT 8, id FROM tags WHERE name IN ('chicken', 'creamy', 'quick');

INSERT INTO ratings (user_id, recipe_id, rating, comment)
VALUES (
  (SELECT id FROM users WHERE username = 'chef_john'),
  8,
  5,
  'Excellent flavor, easy to make!'
);


-- READ --
SELECT id, title, description, average_rating
FROM recipes
ORDER BY title;

SELECT r.title, i.name AS ingredient, ri.amount, m.unit_name
FROM recipes r
JOIN recipe_ingredients ri ON r.id = ri.recipe_id
JOIN ingredients i ON i.id = ri.ingredient_id
JOIN measurements m ON m.id = ri.measurement_id
WHERE r.title = 'Kebasa Pasta'
ORDER BY i.name;

SELECT r.title, t.name AS tag
FROM recipes r
JOIN recipe_tags rt ON r.id = rt.recipe_id
JOIN tags t ON t.id = rt.tag_id
WHERE t.name = 'dessert'
ORDER BY r.title;

SELECT title, average_rating
FROM recipes
WHERE average_rating >= 4.5
ORDER BY average_rating DESC;

-- UPDATE --
UPDATE recipes
SET description = 'A rich, creamy garlic chicken dish with a smooth sauce.',
    cook_time_minutes = 25,
    updated_at = NOW()
WHERE title = 'Creamy Garlic Chicken';

UPDATE recipe_ingredients
SET amount = 2
WHERE recipe_id = (SELECT id FROM recipes WHERE title='Kebasa Pasta')
  AND ingredient_id = (SELECT id FROM ingredients WHERE name='parmesan cheese');

UPDATE ratings
SET rating = 4, comment = 'Still great, just a bit salty this time.'
WHERE user_id = (SELECT id FROM users WHERE username='chef_john')
  AND recipe_id = (SELECT id FROM recipes WHERE title='Kebasa Pasta');


-- DELETE --
DELETE FROM ratings
WHERE user_i d = (SELECT id FROM users WHERE username='chef_john')
  AND recipe_id = (SELECT id FROM recipes WHERE title='Kebasa Pasta');

DELETE FROM recipes
WHERE title = 'Spanish Rice';

DELETE FROM ingredients
WHERE name = 'smoked paprika'
  AND id NOT IN (SELECT ingredient_id FROM recipe_ingredients);

