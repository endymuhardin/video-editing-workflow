# Pre-Production Planning

This folder contains all planning and scripting materials before recording begins.

## Directory Structure

```
00-planning/
├── script/      # Full scripts or talking points
├── outline/     # Topic structure, episode breakdown
├── research/    # Reference docs, links, notes
├── demo-code/   # Working code to demonstrate
└── shotlist/    # Footage requirements per section
```

## Workflow

### 1. Outline (`outline/`)
Start with high-level structure:
- Main topic and subtopics
- Key points to cover
- Logical flow/sequence
- Time estimates per section

Example: `outline/topics.md`
```markdown
# Spring Boot REST API Tutorial

## Topics
1. Project setup (5 min)
2. Create entity class (3 min)
3. Repository layer (5 min)
4. Service layer (5 min)
5. Controller endpoints (10 min)
6. Testing with curl (5 min)

## Prerequisites
- Java 17+
- Maven/Gradle
- IDE (IntelliJ/VSCode)
```

### 2. Script (`script/`)
Detailed talking points and code snippets to show:

Example: `script/episode.md`
```markdown
# Episode Script

## Intro (30 sec)
- What we're building today
- End result preview

## Section 1: Project Setup
[Show browser: start.spring.io]
"Let's create a new Spring Boot project..."

Dependencies to add:
- Spring Web
- Spring Data JPA
- H2 Database

## Section 2: Entity Class
[Switch to IDE]
"First, we'll create our entity..."

​```java
@Entity
public class Product {
    @Id @GeneratedValue
    private Long id;
    private String name;
    private BigDecimal price;
}
​```
```

### 3. Research (`research/`)
Reference materials gathered during preparation:
- Official documentation links
- Stack Overflow solutions
- Blog posts with useful patterns
- Error messages and fixes to mention

### 4. Demo Code (`demo-code/`)
Working, tested code that will be demonstrated:
- Complete project that compiles and runs
- Pre-written code snippets for copy/paste
- Test data or sample requests

Prepare code beforehand to avoid:
- Typos during recording
- Unexpected errors
- Forgetting syntax

### 5. Shot List (`shotlist/`)
Plan required footage types for each section:

Example: `shotlist/footage.md`
```markdown
# Footage Requirements

## Footage Types
- **TH** = Talking Head (camera only)
- **SC** = Screen Capture (IDE, terminal, browser)
- **TH+SC** = Talking Head + Screen (picture-in-picture)
- **BR** = B-Roll (close-ups, cutaways)
- **GFX** = Graphics/Infographic/Illustration

## Section Breakdown

| Section | Duration | Primary | Secondary | Notes |
|---------|----------|---------|-----------|-------|
| Intro | 0:30 | TH | - | Hook + overview |
| What is Spring Boot | 1:00 | TH | GFX | Architecture diagram |
| Project Setup | 2:00 | SC | TH+SC | start.spring.io |
| Entity Class | 3:00 | TH+SC | BR | Close-up typing |
| Repository | 2:00 | SC | - | Code walkthrough |
| Testing | 3:00 | TH+SC | SC | Terminal output |
| Outro | 0:30 | TH | GFX | Subscribe CTA |

## Graphics/Illustrations Needed
- [ ] Spring Boot architecture diagram
- [ ] Request/Response flow diagram
- [ ] Database schema visualization

## B-Roll Ideas
- [ ] Keyboard typing close-up
- [ ] Coffee cup / desk setup
- [ ] Terminal commands running
```

#### Footage Type Guidelines

| Type | When to Use | OBS Scene |
|------|-------------|-----------|
| TH | Explanations, intros, outros | F1 (Talking Head) |
| SC | Code demos, browser, terminal | F3 (Screen Only) |
| TH+SC | Guided walkthroughs | F2 (Screen+Camera) |
| BR | Transitions, emphasis | Record separately |
| GFX | Complex concepts, data flow | Create in Fusion/Canva |

## Tips

1. **Test everything before recording** - Run all demo code to ensure it works
2. **Prepare fallbacks** - Have working code ready if live coding fails
3. **Note timestamps** - Mark where cuts/edits will likely be needed
4. **List B-roll needs** - Screenshots, diagrams, browser tabs to capture
