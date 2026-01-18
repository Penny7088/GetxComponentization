I will implement the modular architecture using Melos and split the business logic into separate feature packages.

### Phase 1: Melos Configuration
1.  **Initialize Melos**:
    *   Create `melos.yaml` in the root directory.
    *   Configure workspace packages (`packages/**`, `apps/**`, `.` ).
    *   Define common scripts (bootstrap, clean, analyze).
2.  **Update Root Dependency**:
    *   Add `melos` to `dev_dependencies` in root `pubspec.yaml`.

### Phase 2: Feature Packages Creation
3.  **Create `feat_splash`**:
    *   Move `lib/pages/splash` to `packages/feat_splash`.
    *   Setup `pubspec.yaml` with dependencies (`lib_base`, `lib_uikit`).
4.  **Create `feat_onboarding`**:
    *   Move `lib/pages/onboarding` to `packages/feat_onboarding`.
    *   Setup `pubspec.yaml`.
5.  **Create `feat_main`**:
    *   Move `lib/pages/main_container` to `packages/feat_main`.
    *   Setup `pubspec.yaml`.
6.  **Create `service_router`**:
    *   Create `packages/service_router` to define route paths and abstract navigation interfaces.
    *   This breaks circular dependencies between features (e.g., Splash -> Main).

### Phase 3: Integration & Cleanup
7.  **Refactor Root App**:
    *   Update `lib/main.dart` and `lib/router/` to aggregate routes from all feature packages.
    *   Remove moved files from `lib/pages/`.
8.  **Bootstrap**:
    *   Run `melos bootstrap` to link all packages.
    *   Verify the project builds successfully.

I will start with **Phase 1: Melos Configuration**.