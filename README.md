# wanikani.r

<!-- badges: start -->
<!-- badges: end -->

An R client for the [WaniKani API v2](https://docs.api.wanikani.com/). WaniKani is a Japanese learning platform that uses spaced repetition to teach kanji and vocabulary.

This package provides a complete interface to all WaniKani API endpoints, including:

- User information and preferences
- Assignments and study queue
- Reviews and review statistics
- Subjects (radicals, kanji, vocabulary)
- Study materials (notes and synonyms)
- Level progressions and resets
- Spaced repetition system information
- Voice actors

## Installation

You can install the development version of wanikani from GitHub:

```r
# install.packages("devtools")
devtools::install_github("yourusername/wanikani.r")
```

## Authentication

To use this package, you need a WaniKani API token. Get yours from:
https://www.wanikani.com/settings/personal_access_tokens

You can provide your API token in two ways:

1. **Environment variable** (recommended):
```r
Sys.setenv(WANIKANI_API_TOKEN = "your_token_here")
```

2. **Function parameter**:
```r
wk_user(api_token = "your_token_here")
```

For convenience, add your token to your `.Renviron` file:
```bash
WANIKANI_API_TOKEN=your_token_here
```

## Quick Start

```r
library(wanikani)

# Get user information
user <- wk_user()
print(user$data$level)
print(user$data$username)

# Get summary of upcoming reviews
summary <- wk_summary()
print(summary$data$next_reviews_at)

# Get all assignments for your current level
assignments <- wk_assignments(levels = user$data$level)
print(length(assignments$data))

# Get all kanji from levels 1-3
kanji <- wk_subjects(types = "kanji", levels = c(1, 2, 3))

# Get review statistics for items you struggle with
low_accuracy <- wk_review_statistics(
  subject_types = "kanji",
  percentages_less_than = 75
)
```

## Usage Examples

### Working with Subjects

```r
# Get all subjects from level 1
subjects_l1 <- wk_subjects(levels = 1)

# Get specific subject by ID
subject <- wk_subjects_by_id(440)
print(subject$data$characters)
print(subject$data$meanings)

# Get vocabulary by slug
vocab <- wk_subjects(slugs = "一")
```

### Managing Study Materials

```r
# Create study material with custom notes
material <- wk_study_materials_create(
  subject_id = 440,
  meaning_note = "Remember: like a tree reaching up to heaven",
  meaning_synonyms = c("tree", "wood", "timber")
)

# Update existing study material
updated <- wk_study_materials_update(
  id = material$data$id,
  meaning_note = "Updated mnemonic"
)
```

### Reviewing Items

```r
# Get recent reviews
recent_reviews <- wk_reviews(
  updated_after = "2024-01-01T00:00:00Z"
)

# Create a review
review <- wk_reviews_create(
  assignment_id = 123456,
  incorrect_meaning_answers = 0,
  incorrect_reading_answers = 1
)
```

### Pagination

The API returns paginated results. You can fetch all pages automatically:

```r
# Fetch all subjects (may take a while!)
all_subjects <- wk_fetch_all_pages(wk_subjects, verbose = TRUE)
print(all_subjects$total_count)

# Fetch with limits
kanji_page1 <- wk_subjects(types = "kanji", levels = 1)

# Check if more pages exist
if (wk_has_next_page(kanji_page1)) {
  # Manually fetch next page or use wk_fetch_all_pages
  all_kanji <- wk_fetch_all_pages(
    wk_subjects,
    types = "kanji",
    levels = 1,
    max_pages = 5
  )
}
```

### Advanced Usage: R6 Client

For more control, use the `WaniKaniClient` R6 class directly:

```r
# Create a client
client <- WaniKaniClient$new(api_token = "your_token")

# Make requests
response <- client$get("/subjects", query = list(levels = "1"))

# Check rate limit
print(client$rate_limit_remaining)
print(client$rate_limit_reset)

# Use different HTTP methods
new_material <- client$post(
  "/study_materials",
  body = list(
    study_material = list(
      subject_id = 440,
      meaning_note = "My note"
    )
  )
)
```

## API Rate Limiting

The WaniKani API has a rate limit of 60 requests per minute. This package automatically tracks rate limit information in the response headers:

```r
client <- WaniKaniClient$new()
response <- client$get("/user")

# Check remaining requests
print(client$rate_limit_remaining)  # e.g., 59
print(client$rate_limit_reset)      # Unix timestamp
```

If you exceed the rate limit, the API will return a 429 error and the package will report when you can try again.

## Available Endpoints

### User
- `wk_user()` - Get user information
- `wk_user_update(preferences)` - Update user preferences

### Summary
- `wk_summary()` - Get lesson and review summary

### Assignments
- `wk_assignments(...)` - Get assignments with filters
- `wk_assignments_by_id(id)` - Get assignment by ID
- `wk_assignments_start(id)` - Start an assignment

### Subjects
- `wk_subjects(...)` - Get subjects with filters
- `wk_subjects_by_id(id)` - Get subject by ID

### Reviews
- `wk_reviews(...)` - Get reviews with filters
- `wk_reviews_by_id(id)` - Get review by ID
- `wk_reviews_create(...)` - Create a review

### Review Statistics
- `wk_review_statistics(...)` - Get review statistics with filters
- `wk_review_statistics_by_id(id)` - Get review statistic by ID

### Study Materials
- `wk_study_materials(...)` - Get study materials with filters
- `wk_study_materials_by_id(id)` - Get study material by ID
- `wk_study_materials_create(...)` - Create study material
- `wk_study_materials_update(id, ...)` - Update study material

### Level Progressions
- `wk_level_progressions(...)` - Get level progressions with filters
- `wk_level_progressions_by_id(id)` - Get level progression by ID

### Resets
- `wk_resets(...)` - Get resets with filters
- `wk_resets_by_id(id)` - Get reset by ID

### Spaced Repetition Systems
- `wk_spaced_repetition_systems(...)` - Get SRS systems with filters
- `wk_spaced_repetition_systems_by_id(id)` - Get SRS system by ID

### Voice Actors
- `wk_voice_actors(...)` - Get voice actors with filters
- `wk_voice_actors_by_id(id)` - Get voice actor by ID

### Pagination Helpers
- `wk_fetch_all_pages(endpoint_function, ...)` - Automatically fetch all pages
- `wk_extract_data(response)` - Extract data from response
- `wk_next_page_url(response)` - Get next page URL
- `wk_has_next_page(response)` - Check if more pages exist

## Documentation

For detailed documentation on each function, use R's help system:

```r
?wk_subjects
?WaniKaniClient
?wk_fetch_all_pages
```

See the package vignettes for more detailed examples:

```r
browseVignettes("wanikani")
```

## Testing

The package includes comprehensive tests. Run them with:

```r
devtools::test()
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details.

## See Also

- [WaniKani API Documentation](https://docs.api.wanikani.com/)
- [WaniKani Website](https://www.wanikani.com/)

## Acknowledgments

This package is not officially affiliated with WaniKani or Tofugu LLC.
