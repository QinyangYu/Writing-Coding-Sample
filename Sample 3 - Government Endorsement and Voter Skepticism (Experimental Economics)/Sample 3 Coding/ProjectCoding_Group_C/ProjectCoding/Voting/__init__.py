from otree.api import *
import random

doc = """
20-round voting experiment with disclosure varying by group type (control vs treatment).
"""

class C(BaseConstants):
    NAME_IN_URL = 'Voting'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 20
    P_FOR_A = 2/3

    STYLE = 'Voting_stuff/style.html'
    SCRIPT = 'Voting_stuff/script.html'

class Subsession(BaseSubsession):
    def creating_session(subsession):
        pass  # No need to assign anything here anymore


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    # Treatment group
    group_type = models.StringField()
    government_type = models.StringField()

    # Internal logic
    true_state = models.StringField()
    disclosure = models.StringField()

    # Results fields
    round_payoff = models.CurrencyField()

    # Voting choice
    vote = models.StringField(
        choices=[('Vote', 'Vote'), ('Not Vote', 'Not Vote')],
        label='Do you choose to vote or not?',
        widget=widgets.RadioSelect
    )

    # Demographic fields
    name = models.StringField(label="What is your name?")
    age = models.IntegerField(label="What is your age?", min=13, max=100)
    gender = models.StringField(
        choices=["Male", "Female", "Non-binary", "Prefer not to say"],
        label="What is your gender?",
        widget=widgets.RadioSelect
    )
    nationality = models.StringField(label="What is your nationality?")
    education = models.StringField(
        choices=["High school", "Bachelor's", "Master's", "PhD", "Other"],
        label="What is your highest level of education?",
        widget=widgets.RadioSelect
    )
    employment_status = models.StringField(
        choices=["Student", "Employed full-time", "Employed part-time", "Unemployed", "Other"],
        label="What is your current employment status?",
        widget=widgets.RadioSelect
    )
    political_affiliation = models.StringField(
        label="How would you describe your political affiliation?",
        choices=["Liberal", "Moderate", "Conservative", "Other", "Prefer not to say"],
        widget=widgets.RadioSelect
    )
    trust_government = models.IntegerField(
        label="On a scale from 1 (no trust) to 5 (full trust), how much do you trust the government?",
        choices=[(i, str(i)) for i in range(1, 6)],
        widget=widgets.RadioSelect
    )

    def set_round_state(self):
        # === Step 1: Import types from participant.vars (set in Instructions app) ===
        self.group_type = self.participant.vars.get('group_type')
        self.government_type = self.participant.vars.get('government_type')

        # === Step 2: First and last round only use good/bad and fixed disclosure ===
        if self.round_number in [1, C.NUM_ROUNDS]:
            self.true_state = random.choice(['<span style="color: orange;"><b>good</b></span>', 
                                             '<span style="color: blue;"><b>bad</b></span>'])
            self.disclosure = 'The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: blue;"><b>bad</b></span>.'
            return

        # === Step 3: All other rounds ===
        self.true_state = random.choice(['<span style="color: orange;"><b>good</b></span>', 
                                         '<span style="color: blue;"><b>bad</b></span>', 
                                         '<span style="color: purple;"><b>horrible</b></span>'])

        control_options = {
            '<span style="color: blue;"><b>bad</b></span>': ['The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: blue;"><b>bad</b></span>.'],
            '<span style="color: purple;"><b>horrible</b></span>': ['The true state is <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: blue;"><b>bad</b></span> or <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: orange;"><b>good</b></span>, <span style="color: blue;"><b>bad</b></span>, or <span style="color: purple;"><b>horrible</b></span>.'],
        }

        B_options = {
            '<span style="color: blue;"><b>bad</b></span>': ['The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: blue;"><b>bad</b></span>.'],
            '<span style="color: purple;"><b>horrible</b></span>': ['The true state is <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: blue;"><b>bad</b></span> or <span style="color: purple;"><b>horrible</b></span>.', 
                         'The true state is either <span style="color: orange;"><b>good</b></span>, <span style="color: blue;"><b>bad</b></span>, or <span style="color: purple;"><b>horrible</b></span>.'],
        }

        p = C.P_FOR_A

        # === Step 4: Choose disclosure based on group type and state ===
        if self.group_type == 'C':
            if self.true_state == '<span style="color: orange;"><b>good</b></span>':
                self.disclosure = random.choices(['The true state is <span style="color: orange;"><b>good</b></span>.', 
                                                  'The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: blue;"><b>bad</b></span>.'], weights=[p, 1 - p])[0]
            else:
                self.disclosure = random.choice(control_options[self.true_state])

        elif self.group_type == 'B':
            if self.true_state == '<span style="color: orange;"><b>good</b></span>':
                self.disclosure = random.choices(['The true state is <span style="color: orange;"><b>good</b></span>.', 
                                                  'The true state is either <span style="color: orange;"><b>good</b></span> or <span style="color: blue;"><b>bad</b></span>.'], weights=[p, 1 - p])[0]
            else:
                self.disclosure = random.choice(B_options[self.true_state])

    def calculate_payoff(self):
        # Calculate payoff based on vote choice and true state
        if self.vote == 'Vote':
            if self.true_state == '<span style="color: orange;"><b>good</b></span>':
                self.round_payoff = cu(2)
            elif self.true_state == '<span style="color: blue;"><b>bad</b></span>':
                self.round_payoff = cu(-1)
            elif self.true_state == '<span style="color: purple;"><b>horrible</b></span>':
                self.round_payoff = cu(-3)
        else:  # Not Vote
            self.round_payoff = cu(0.0)

        self.session.config['currency_decimal_places'] = 2

        # Add to participant vars to keep track of history
        if 'history' not in self.participant.vars:
            self.participant.vars['history'] = []

        # Store this round's results
        self.participant.vars['history'].append({
            'round': self.round_number,
            'choice': self.vote,
            'disclosure': self.disclosure,
            'payoff': self.round_payoff,
            'true_state': self.true_state
        })

        # Update total payoff
        self.payoff = self.round_payoff

    def calculate_final_payoff(self):
        # Get the full history
        history = self.participant.vars.get('history', [])

        if not history:
            return cu(0)

        # Randomly select 1 round 
        num_rounds_to_select = min(1, len(history))
        selected_rounds = random.sample(history, num_rounds_to_select)

        # Calculate total payoff from selected rounds
        total_selected_payoff = sum(round_data['payoff'] for round_data in selected_rounds)

        # Store selected rounds for display
        self.participant.vars['selected_rounds'] = selected_rounds
        self.participant.vars['final_payoff'] = total_selected_payoff

        return cu(total_selected_payoff)



# other unimportant pages
# player.round_number guarantees they only show up in round one


class Voting(Page):
    form_model = 'player'
    form_fields = ['vote']


    def vars_for_template(player):
        # Safety net to set up round data
        if player.field_maybe_none('disclosure') is None:
            player.set_round_state()

        # Get history for table display
        history = player.participant.vars.get('history', [])

        return {
            'disclosure': player.disclosure,
            'government_type': player.government_type,
            'history': history,
            'current_round': player.round_number,
        }


class RoundResults(Page):
    def is_displayed(player):
        # Skip the last round results and go straight to survey
        return player.round_number < C.NUM_ROUNDS

    def before_next_page(player, timeout_happened):
        # Prepare next round's state
        player.set_round_state()

    def vars_for_template(player):
        # Calculate payoff for this round
        player.calculate_payoff()

        return {
            'true_state': player.true_state,
            'vote_choice': player.vote,
            'round_payoff': player.round_payoff,
            'round_number': player.round_number
        }

class FinalQuestion(Page):
    form_model = 'player'

    def is_displayed(player):
        return player.round_number == C.NUM_ROUNDS



class Survey(Page):
    form_model = 'player'
    form_fields = [
        'name', 'age', 'gender', 'nationality',
        'education', 'employment_status',
        'political_affiliation', 'trust_government'
    ]

    def is_displayed(player):
        return player.round_number == C.NUM_ROUNDS

    def before_next_page(player, timeout_happened):
        # Calculate the final payoff before going to the Thanks page
        if player.round_number == C.NUM_ROUNDS:
            # Make sure to calculate the last round's payoff first
            player.calculate_payoff()
            player.calculate_final_payoff()



class Thanks(Page):
    def is_displayed(player):
        return player.round_number == C.NUM_ROUNDS

    def vars_for_template(player):
        # Get full history and selected rounds for final results
        history = player.participant.vars.get('history', [])
        selected_rounds = player.participant.vars.get('selected_rounds', [])
        final_payoff = player.participant.vars.get('final_payoff', 0)

        return {
            'history': history,
            'selected_rounds': selected_rounds,
            'final_payoff': final_payoff
        }


page_sequence = [Voting, RoundResults, FinalQuestion ,Survey, Thanks]