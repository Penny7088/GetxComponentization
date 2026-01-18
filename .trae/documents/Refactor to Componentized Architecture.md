I will refactor the project into a modular architecture using a local package strategy. This involves splitting the codebase into independent packages managed within a `packages` directory.

### Phase 1: Infrastructure Setup & Foundation Layer
1.  **Create Directory Structure**:
    *   Create `packages/` root directory.
2.  **Create `lib_base` Package**:
    *   **Goal**: Isolate core logic, base classes, and utilities.
    *   **Content**: `lib/base/` (CommonController, BaseState, Utils, Networking), `lib/router/` (Base routing interfaces if any).
    *   **Dependencies**: `get`, `dio`, `logger`, etc.
3.  **Create `lib_uikit` Package**:
    *   **Goal**: Isolate design system and common UI components.
    *   **Content**: `lib/theme/`, `lib/widget/`, `lib/base/utils/image_utils.dart`.
    *   **Dependencies**: `flutter_screenutil`, `auto_size_text`, `flutter_svg`.

### Phase 2: Feature Layer Extraction (Incremental)
4.  **Create `feat_splash` Package**:
    *   Move `lib/pages/splash/` to this new package.
5.  **Create `feat_onboarding` Package**:
    *   Move `lib/pages/onboarding/` to this new package.
6.  **Create `feat_main` Package**:
    *   Move `lib/pages/main_container/` to this new package.

### Phase 3: App Shell Integration
7.  **Refactor Root Project**:
    *   Update `pubspec.yaml` to depend on local packages (`path: packages/lib_base`, etc.).
    *   Update `main.dart` and `app_pages.dart` to import from these new packages.
    *   Fix all import paths across the project.

This approach minimizes risk by moving foundational elements first, then features one by one. I will start with **Phase 1**.