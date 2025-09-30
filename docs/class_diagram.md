# BrainBuster – Klassendiagramm

```mermaid
classDiagram
  class User {
    +string username
    +string display_name
    +integer total_points
    +enum role
    +add_points!(points)
  }

  class Category {
    +string name
    +text description
    +boolean featured
  }

  class Question {
    +text content
    +string difficulty
    +integer base_points
    +integer time_limit_seconds
    +correct_option()
  }

  class AnswerOption {
    +string text
    +boolean correct
  }

  class Match {
    +string mode
    +string state
    +integer question_count
    +integer time_per_question
    +string share_code
    +leaderboard()
  }

  class MatchQuestion {
    +integer position
  }

  class MatchParticipation {
    +integer score
    +integer correct_count
    +integer incorrect_count
    +integer best_streak
    +integer average_response_ms
    +register_attempt!()
    +finish!()
  }

  class QuestionAttempt {
    +boolean correct
    +integer response_time_ms
    +integer awarded_points
  }

  class Achievement {
    +string code
    +string name
    +integer points_bonus
  }

  class UserAchievement {
    +datetime awarded_at
  }

  User "1" -- "many" MatchParticipation
  User "1" -- "many" Match : creator
  User "many" -- "many" Achievement : through UserAchievement
  Category "1" -- "many" Question
  Question "1" -- "many" AnswerOption
  Match "1" -- "many" MatchQuestion
  MatchQuestion "many" -- "1" Question
  Match "1" -- "many" MatchParticipation
  MatchParticipation "1" -- "many" QuestionAttempt
  QuestionAttempt "many" -- "1" AnswerOption
```

Dieses Diagramm zeigt die wichtigsten Beziehungen der BrainBuster-Domäne. Für eine detaillierte Beschreibung der Services und Spielabläufe siehe `README.md`.
