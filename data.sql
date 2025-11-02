-- ===========================================
-- Sample Data for Recipe Database
-- ===========================================

-- USERS
INSERT INTO users (username, display_name, email)
VALUES
  ('chef_anna', 'Anna Smith', 'anna@example.com'),
  ('chef_john', 'John Doe', 'john@example.com'),
  ('chef_lisa', 'Lisa Green', 'lisa@example.com')
ON CONFLICT DO NOTHING;

-- MEASUREMENTS
INSERT INTO measurements (unit_name, abbreviation)
VALUES
  ('package', 'pkg'),
  ('pound', 'lb'),
  ('cup', 'c'),
  ('tablespoon', 'Tbsp'),
  ('teaspoon', 'tsp'),
  ('ounce', 'oz'),
  ('clove', 'clv'),
  ('piece', 'pc')
ON CONFLICT DO NOTHING;

-- INGREDIENTS
INSERT INTO ingredients (name)
VALUES
  ('kebasa'),
  ('penne pasta'),
  ('chicken broth'),
  ('heavy whipping cream'),
  ('parmesan cheese'),
  ('chili powder'),
  ('Bisquick'),
  ('ground beef'),
  ('onion'),
  ('salt'),
  ('garlic'),
  ('tomato sauce'),
  ('italian seasoning'),
  ('mushrooms'),
  ('green pepper'),
  ('mozzarella cheese'),
  ('sugar'),
  ('all-purpose flour'),
  ('cocoa powder'),
  ('baking powder'),
  ('baking soda'),
  ('vegetable oil'),
  ('vanilla extract'),
  ('milk'),
  ('eggs'),
  ('butter'),
  ('powdered sugar'),
  ('peanut butter'),
  ('cinnamon'),
  ('sea salt'),
  ('dark brown sugar'),
  ('applesauce'),
  ('apple'),
  ('cream cheese'),
  ('confectioners’ sugar'),
  ('molasses'),
  ('rice'),
  ('salsa'),
  ('taco seasoning'),
  ('enchilada sauce'),
  ('fat free cheddar cheese'),
  ('russet potatoes'),
  ('olive oil'),
  ('garlic salt'),
  ('smoked paprika'),
  ('onion powder'),
  ('tomato'),
  ('cilantro'),
  ('nacho cheese'),
  ('light sour cream')
ON CONFLICT DO NOTHING;

-- RECIPES
INSERT INTO recipes (author_id, title, description, instructions, prep_time_minutes, cook_time_minutes, servings)
VALUES
  ((SELECT id FROM users WHERE username='chef_anna'),
   'Kebasa Pasta',
   'Creamy pasta with kebasa sausage and parmesan cheese.',
   'Brown kebasa. Add chicken broth and heavy whipping cream; return to boil. Add noodles and boil for 20 min. Remove from heat, stir in parmesan and chili powder.',
   10, 25, 6),

  ((SELECT id FROM users WHERE username='chef_john'),
   'Easy Deep Dish Pizza',
   'A simple Bisquick-based deep dish pizza with ground beef and veggies.',
   'Preheat oven to 425°F. Mix Bisquick and water into dough. Prepare beef mixture with onion, garlic, and tomato sauce. Spread dough in pan, top with mixture, mushrooms, peppers, and cheese. Bake until golden.',
   20, 25, 8),

  ((SELECT id FROM users WHERE username='chef_lisa'),
   'Chocolate Cake',
   'Classic chocolate cake with rich cocoa frosting.',
   'Mix dry ingredients, add wet, bake at 350°F for 30–35 minutes. Frost with cocoa buttercream.',
   20, 35, 10),

  ((SELECT id FROM users WHERE username='chef_anna'),
   'Peanut Butter Waffles',
   'Fluffy waffles with creamy peanut butter flavor.',
   'Combine dry and wet ingredients separately, then mix and cook in waffle iron.',
   15, 20, 6),

  ((SELECT id FROM users WHERE username='chef_lisa'),
   'Spice Cake',
   'Warm, moist cake with cinnamon, nutmeg, and ginger.',
   'Mix dry and wet ingredients separately, combine, bake at 350°F for 45–50 minutes, and frost with cream cheese icing.',
   20, 50, 12),

  ((SELECT id FROM users WHERE username='chef_john'),
   'Spanish Rice',
   'Quick and simple Spanish-style rice with salsa.',
   'Cook rice with chicken broth and salsa until tender.',
   5, 25, 4),

  ((SELECT id FROM users WHERE username='chef_john'),
   'Loaded Taco Potato Bowls',
   'High-protein taco-style potato bowls with cheese and enchilada sauce.',
   'Cook and season beef, roast potatoes, then assemble with toppings and sauces.',
   15, 40, 4);

-- RECIPE INGREDIENTS (simplified amounts)
-- Kebasa Pasta
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount, note)
SELECT r.id, i.id, m.id, a.amount, a.note
FROM (VALUES
  ('Kebasa Pasta', 'Kebasa', 'package', 1, NULL),
  ('Kebasa Pasta', 'penne pasta', 'pound', 1, NULL),
  ('Kebasa Pasta', 'chicken broth', 'ounce', 32, NULL),
  ('Kebasa Pasta', 'heavy whipping cream', 'ounce', 16, NULL),
  ('Kebasa Pasta', 'parmesan cheese', 'cup', 2, '1.5–2 cups'),
  ('Kebasa Pasta', 'chili powder', 'tablespoon', 1, 'up to 1 Tbsp')
) AS a(recipe, ingredient, measure, amount, note)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- Easy Deep Dish Pizza
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount)
SELECT r.id, i.id, m.id, a.amount
FROM (VALUES
  ('Easy Deep Dish Pizza','Bisquick','cup',3),
  ('Easy Deep Dish Pizza','water','cup',0.75),
  ('Easy Deep Dish Pizza','ground beef','pound',1),
  ('Easy Deep Dish Pizza','onion','cup',0.5),
  ('Easy Deep Dish Pizza','salt','teaspoon',0.5),
  ('Easy Deep Dish Pizza','garlic','clove',2),
  ('Easy Deep Dish Pizza','tomato sauce','ounce',15),
  ('Easy Deep Dish Pizza','Italian seasoning','teaspoon',1),
  ('Easy Deep Dish Pizza','mushrooms','ounce',4.5),
  ('Easy Deep Dish Pizza','green pepper','cup',0.5),
  ('Easy Deep Dish Pizza','mozzarella cheese','cup',2)
) AS a(recipe, ingredient, measure, amount)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- Chocolate Cake (short version)
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount)
SELECT r.id, i.id, m.id, a.amount
FROM (VALUES
  ('Chocolate Cake','sugar','cup',2),
  ('Chocolate Cake','all-purpose flour','cup',1.75),
  ('Chocolate Cake','cocoa powder','cup',0.75),
  ('Chocolate Cake','baking powder','teaspoon',1.5),
  ('Chocolate Cake','baking soda','teaspoon',1.5),
  ('Chocolate Cake','salt','teaspoon',1),
  ('Chocolate Cake','eggs','piece',2),
  ('Chocolate Cake','milk','cup',1),
  ('Chocolate Cake','vegetable oil','cup',0.5),
  ('Chocolate Cake','vanilla extract','teaspoon',2)
) AS a(recipe, ingredient, measure, amount)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- Peanut Butter Waffles
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount)
SELECT r.id, i.id, m.id, a.amount
FROM (VALUES
  ('Peanut Butter Waffles','all-purpose flour','cup',2),
  ('Peanut Butter Waffles','sugar','tablespoon',2),
  ('Peanut Butter Waffles','baking powder','teaspoon',2),
  ('Peanut Butter Waffles','cinnamon','teaspoon',0.5),
  ('Peanut Butter Waffles','sea salt','teaspoon',0.25),
  ('Peanut Butter Waffles','milk','cup',2),
  ('Peanut Butter Waffles','eggs','piece',2),
  ('Peanut Butter Waffles','peanut butter','cup',0.5),
  ('Peanut Butter Waffles','butter','tablespoon',4)
) AS a(recipe, ingredient, measure, amount)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- Spanish Rice
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount)
SELECT r.id, i.id, m.id, a.amount
FROM (VALUES
  ('Spanish Rice','rice','cup',1.5),
  ('Spanish Rice','chicken broth','cup',2),
  ('Spanish Rice','salsa','cup',1)
) AS a(recipe, ingredient, measure, amount)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- Loaded Taco Potato Bowls
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, measurement_id, amount)
SELECT r.id, i.id, m.id, a.amount
FROM (VALUES
  ('Loaded Taco Potato Bowls','ground beef','ounce',24),
  ('Loaded Taco Potato Bowls','taco seasoning','package',1),
  ('Loaded Taco Potato Bowls','enchilada sauce','cup',0.25),
  ('Loaded Taco Potato Bowls','fat free cheddar cheese','cup',1),
  ('Loaded Taco Potato Bowls','russet potatoes','ounce',20),
  ('Loaded Taco Potato Bowls','olive oil','tablespoon',1),
  ('Loaded Taco Potato Bowls','garlic salt','teaspoon',1),
  ('Loaded Taco Potato Bowls','smoked paprika','teaspoon',1),
  ('Loaded Taco Potato Bowls','onion powder','teaspoon',1),
  ('Loaded Taco Potato Bowls','tomato','piece',1),
  ('Loaded Taco Potato Bowls','cilantro','tablespoon',2),
  ('Loaded Taco Potato Bowls','nacho cheese','cup',0.25),
  ('Loaded Taco Potato Bowls','light sour cream','cup',0.25)
) AS a(recipe, ingredient, measure, amount)
JOIN recipes r ON r.title = a.recipe
JOIN ingredients i ON i.name = a.ingredient
JOIN measurements m ON m.unit_name = a.measure;

-- TAGS (if not already inserted)
INSERT INTO tags (name)
VALUES
  ('breakfast'),
  ('dessert'),
  ('baked'),
  ('instant pot'),
  ('cast iron'),
  ('quick'),
  ('savory'),
  ('high protein'),
  ('comfort food')
ON CONFLICT DO NOTHING;

-- RECIPE TAGS
INSERT INTO recipe_tags (recipe_id, tag_id)
SELECT r.id, t.id
FROM (VALUES
  ('Kebasa Pasta','comfort food'),
  ('Easy Deep Dish Pizza','baked'),
  ('Chocolate Cake','dessert'),
  ('Peanut Butter Waffles','breakfast'),
  ('Spice Cake','dessert'),
  ('Spanish Rice','quick'),
  ('Loaded Taco Potato Bowls','high protein')
) AS a(recipe, tag)
JOIN recipes r ON r.title = a.recipe
JOIN tags t ON t.name = a.tag;

-- RATINGS
INSERT INTO ratings (user_id, recipe_id, rating, comment)
SELECT u.id, r.id, a.rating, a.comment
FROM (VALUES
  ('chef_john','Kebasa Pasta',5,'So creamy and easy!'),
  ('chef_anna','Chocolate Cake',5,'My favorite chocolate cake ever.'),
  ('chef_lisa','Spanish Rice',4,'Simple and tasty side dish.'),
  ('chef_john','Loaded Taco Potato Bowls',5,'Perfect post-workout meal.'),
  ('chef_lisa','Peanut Butter Waffles',4,'Great breakfast, freezes well.')
) AS a(usern, rec, rating, comment)
JOIN users u ON u.username = a.usern
JOIN recipes r ON r.title = a.rec;
