// @ts-ignore

import { TestBed } from '@angular/core/testing';
import { OnboardingGuard } from './onboarding.guard';

describe('OnboardingGuard', () => {
  let guard: OnboardingGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        { provide: 'Compiler', useValue: { getComponentFromError: () => null } }
      ]
    });
    guard = TestBed.inject(OnboardingGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
