from otree.api import *
import random

doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'Instructions'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1
    P_FOR_A = 0.7
    ENDOWMENT = cu(1000)
    PRIOR_ACCURACY = 0.85
    SIGNAL_ACCURACY = 0.80

    STYLE = 'Voting_stuff/style.html'
    SCRIPT = 'Voting_stuff/script.html'


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):

    prolific_id = models.StringField(label="Please provide your PROLIFIC ID")

    consent = models.BooleanField(default=0)
    
    # Treatment group
    group_type = models.StringField()
    government_type = models.StringField()
    government_type_2 = models.StringField()
    government_type_3 = models.StringField()

    # Internal logic
    true_state = models.StringField()
    disclosure = models.StringField()

    # test1
    probability_question = models.StringField(
        choices=[
            ('Yes', 'Yes'),
            ('No', 'No')
        ],
        label="Are the states <span style=‘color: orange;’><b>good</b></span>, <span style=‘color: blue;’><b>bad</b></span>, and <span style=‘color: purple;’><b>horrible</b></span> equally likely to occur?"
    )

    # For test2 - policy choices when state is "a"
    policy_a = models.BooleanField(label='"{a}"', widget=widgets.CheckboxInput, blank=True)
    policy_ab = models.BooleanField(label='"{a,b}"', widget=widgets.CheckboxInput, blank=True)
    policy_ac = models.BooleanField(label='"{a,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_abc = models.BooleanField(label='"{a,b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_b = models.BooleanField(label='"{b}"', widget=widgets.CheckboxInput, blank=True)
    policy_bc = models.BooleanField(label='"{b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_c = models.BooleanField(label='"{c}"', widget=widgets.CheckboxInput, blank=True)

    # For test3 - policy choices when state is "b"
    policy_b_state_b = models.BooleanField(label='"{b}"', widget=widgets.CheckboxInput, blank=True)
    policy_ab_state_b = models.BooleanField(label='"{a,b}"', widget=widgets.CheckboxInput, blank=True)
    policy_bc_state_b = models.BooleanField(label='"{b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_abc_state_b = models.BooleanField(label='"{a,b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_a_state_b = models.BooleanField(label='"{a}"', widget=widgets.CheckboxInput, blank=True)
    policy_ac_state_b = models.BooleanField(label='"{a,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_c_state_b = models.BooleanField(label='"{c}"', widget=widgets.CheckboxInput, blank=True)

    # For test4 - policy choices when state is "c"
    policy_c_state_c = models.BooleanField(label='"{c}"', widget=widgets.CheckboxInput, blank=True)
    policy_ac_state_c = models.BooleanField(label='"{a,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_bc_state_c = models.BooleanField(label='"{b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_abc_state_c = models.BooleanField(label='"{a,b,c}"', widget=widgets.CheckboxInput, blank=True)
    policy_a_state_c = models.BooleanField(label='"{a}"', widget=widgets.CheckboxInput, blank=True)
    policy_ab_state_c = models.BooleanField(label='"{a,b}"', widget=widgets.CheckboxInput, blank=True)
    policy_b_state_c = models.BooleanField(label='"{b}"', widget=widgets.CheckboxInput, blank=True)

    # Payoff questions for test5
    payoff_vote_a = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="1. What is your additional payoff if you <b>vote</b> and the true state is  <span style='color: orange;'><b>good</b></span>?",
        widget=widgets.RadioSelect
    )

    payoff_not_vote_a = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="2. What is your additional payoff if you do <b>not vote</b> and the true state is <span style='color: orange;'><b>good</b></span>?",
        widget=widgets.RadioSelect
    )

    payoff_vote_b = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="3. What is your additional payoff if you <b>vote</b> and the true state is <span style='color: blue;'><b>bad</b></span>?",
        widget=widgets.RadioSelect
    )

    payoff_not_vote_b = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="4. What is your additional payoff if you do <b>not vote</b> vote and the true state is <span style='color: blue;'><b>bad</b></span>?",
        widget=widgets.RadioSelect
    )

    payoff_vote_c = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="5. What is your additional payoff if you <b>vote</b> and the true state is <span style='color: purple;'><b>horrible</b></span>?",
        widget=widgets.RadioSelect
    )

    payoff_not_vote_c = models.StringField(
        choices=['$-3', '$-1', '$0', '$2'],
        label="6. What is your additional payoff if you do <b>not vote</b> vote and the true state is <span style='color: purple;'><b>horrible</b></span>?",
        widget=widgets.RadioSelect
    )

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


    def set_types(self):
        if 'group_type' not in self.participant.vars:
            self.participant.vars['group_type'] = random.choice(['C', 'B'])

        self.group_type = self.participant.vars['group_type']
        self.government_type = "Neutral" if self.group_type == 'C' else "Biased"
        self.government_type_2 = ("The government's information disclosure strategy is closely related to its own preference. "
                          "Unlike you, the government <b>does not</b> have specific preferences towards the two policies. <br><br> "
                          "In other words, the government is completely <span style='color: red;'><b>neutral</b></span>. "
                          "It is indifferent between the <b>old policy</b> and the <b>new policy</b>. "
                          "Your voting decision <b>will not affect</b> government welfare. <br><br>"
                          " You should assume this preference throughout the experiment.") if self.group_type == 'C' else (
                          "The government's information disclosure strategy is closely related to its own preference. "
                          "Just like you, the government <b>also</b> has specific preferences towards the two policies. <br><br> "
                          "In other words, the government is completely <span style='color: red;'><b>biased</b></span>. "
                          "Specifically, it strongly prefers the <b>new policy</b> to the old policy. "
                          "Your voting decision <b>will significantly affect</b> government welfare.<br><br> "
                          "You should assume this preference throughout the experiment.")
        self.government_type_3 = "neutral" if self.group_type == 'C' else "biased"

        # Save to carry over to next app
        self.participant.vars['government_type'] = self.government_type


# PAGES
class Welcome(Page):
    form_model = 'player'
    form_fields = ['prolific_id']

    @staticmethod
    def before_next_page(player, timeout_happened):
        player.set_types()

    
class Welcome2(Page):
    
    @staticmethod
    def is_displayed(player):
        return player.round_number == 1

class Consent_Form(Page):
    form_model = 'player'
    form_fields = ['consent']

    @staticmethod
    def before_next_page(player, timeout_happened):

        player.participant.label = player.prolific_id

class No_Consent(Page):
    @staticmethod
    def is_displayed(player):
        return player.consent == 0

class Instruction1(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1
    
class Instruction2(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1
    
class Instruction3(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1

class Instruction4(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1
    
class Instruction5(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1
    
class Instruction6(Page):

    @staticmethod
    def is_displayed(player):
        return player.round_number == 1

class Loading(Page):
    timeout_seconds = 1

class test1(Page):
    form_model = 'player'
    form_fields = ['probability_question']

    def is_displayed(player):
        return player.round_number == 1


class test2(Page):
    form_model = 'player'
    form_fields = ['policy_a', 'policy_ab', 'policy_ac', 'policy_abc', 'policy_b', 'policy_bc', 'policy_c']

    def is_displayed(player):
        return player.round_number == 1

    def error_message(player, values):
        # Check if all correct options are selected and no incorrect options are selected
        correct_selected = (values['policy_a'] and values['policy_ab'] and
                            values['policy_ac'] and values['policy_abc'])
        incorrect_selected = (values['policy_b'] or values['policy_bc'] or values['policy_c'])

        if not (correct_selected and not incorrect_selected):
            return "Please choose only correct answers to proceed."


class test3(Page):
    form_model = 'player'
    form_fields = ['policy_b_state_b', 'policy_ab_state_b', 'policy_bc_state_b',
                   'policy_abc_state_b', 'policy_a_state_b', 'policy_ac_state_b', 'policy_c_state_b']

    def is_displayed(player):
        return player.round_number == 1

    def error_message(player, values):
        # Check if all correct options are selected and no incorrect options are selected
        correct_selected = (values['policy_b_state_b'] and values['policy_ab_state_b'] and
                            values['policy_bc_state_b'] and values['policy_abc_state_b'])
        incorrect_selected = (values['policy_a_state_b'] or values['policy_ac_state_b'] or
                              values['policy_c_state_b'])

        if not (correct_selected and not incorrect_selected):
            return "Please choose only correct answers to proceed."


class test4(Page):
    form_model = 'player'
    form_fields = ['policy_c_state_c', 'policy_ac_state_c', 'policy_bc_state_c',
                   'policy_abc_state_c', 'policy_a_state_c', 'policy_ab_state_c', 'policy_b_state_c']

    def is_displayed(player):
        return player.round_number == 1

    def error_message(player, values):
        # Check if all correct options are selected and no incorrect options are selected
        correct_selected = (values['policy_c_state_c'] and values['policy_ac_state_c'] and
                            values['policy_bc_state_c'] and values['policy_abc_state_c'])
        incorrect_selected = (values['policy_a_state_c'] or values['policy_ab_state_c'] or
                              values['policy_b_state_c'])

        if not (correct_selected and not incorrect_selected):
            return "Please choose only correct answers to proceed."


class test5(Page):
    form_model = 'player'
    form_fields = [
        'payoff_vote_a',
        'payoff_not_vote_a',
        'payoff_vote_b',
        'payoff_not_vote_b',
        'payoff_vote_c',
        'payoff_not_vote_c'
    ]

    def is_displayed(player):
        return player.round_number == 1

    def error_message(player, values):
        errors = []

        # Check each question
        if values['payoff_vote_a'] != '$2':
            errors.append("Question 1: Incorrect!")

        if values['payoff_not_vote_a'] != '$0':
            errors.append(
                "Question 2: Incorrect!")

        if values['payoff_vote_b'] != '$-1':
            errors.append("Question 3: Incorrect!")

        if values['payoff_not_vote_b'] != '$0':
            errors.append(
                "Question 4: Incorrect!")

        if values['payoff_vote_c'] != '$-3':
            errors.append("Question 5: Incorrect!")

        if values['payoff_not_vote_c'] != '$0':
            errors.append(
                "Question 6: Incorrect!")

        if errors:
            return " ".join(errors)

class Succeeded(Page):
    pass


page_sequence = [Welcome, Welcome2, Loading, Consent_Form, Loading, No_Consent, Instruction1, Instruction2, Instruction3, Instruction4, Instruction5, Instruction6, test1, Loading, test2, Loading, test3, Loading, test4, Loading, test5, Loading, Succeeded]
