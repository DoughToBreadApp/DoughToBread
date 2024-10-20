import * as admin from 'firebase-admin';

const firebaseConfig = require('./DoughToBreadApp_Firebase_Admin.json'); 


admin.initializeApp({
  credential: admin.credential.cert(firebaseConfig),
  databaseURL: 'https://doughtobreadapp.firebaseio.com'
});

const db = admin.firestore();

interface Subsection {
  title: string;
  content: string;
}

interface Section {
  title: string;
  content: string;
  subsections: Subsection[];
}

interface Module {
  name: string;
  description: string;
  sections: Section[];
}

const moduleData: Module = {
  name: "Module 1: Understanding Financial Basics",
  description: "This module will equip you with the essential tools to manage your money effectively, save for the future, and make your first investments.",
  sections: [
    {
      title: "Welcome to Understanding Financial Basics",
      content: "Welcome to the first step on your journey to financial empowerment! This module will equip you with the essential tools to manage your money effectively, save for the future, and make your first investments. Here's to transforming your financial dough into a prosperous loaf of bread!",
      subsections: [
        {
          title: "Welcome Screen",
          content: "Embark on your financial journey with the mastery of money management. Let's turn your financial dough into rising bread!"
        }
      ]
    },
    {
      title: "Budgeting: Crafting a Plan for Your Income and Expenses",
      content: "Discover the power of a budget—a strategic plan that enables you to control your financial destiny. Learn the difference between income and expenses and how a well-crafted budget can be your roadmap to financial success.",
      subsections: [
        {
          title: "Introduction to Budgeting",
          content: "Learn the difference between income and expenses and how a well-crafted budget can be your roadmap to financial success."
        },
        {
          title: "Categories of Budgeting",
          content: `Explore the three main categories of expenses:\n
            - Fixed Expenses: Regular payments like rent or mortgage, insurance, and car payments.\n
            - Variable Expenses: Costs that vary, such as utility bills, groceries, and fuel.\n
            - Discretionary Expenses: Non-essential spending, including dining out, entertainment, and shopping.`
        },
        {
          title: "Crafting Your Budget",
          content: `Follow a step-by-step guide to create a personalized budget:\n
            1. Identify Your Income: Sum up all sources of monthly income.\n
            2. List Your Expenses: Catalog all your monthly expenses, fixed and variable.\n
            3. Set Priorities: Determine necessities versus luxuries.\n
            4. Allocate Funds: Assign your income to cover all expenses, ensuring necessities are prioritized.\n
            5. Plan for Savings: Set aside a portion of income for emergency funds, short-term and long-term savings.`
        },
        {
          title: "Budgeting Best Practices",
          content: `Gain tips on maintaining your budget, such as:\n
            - Tracking your spending to stay within budget limits.\n
            - Reviewing and adjusting your budget monthly.\n
            - Using budgeting apps to simplify the process.`
        }
      ]
    },
    {
      title: "Saving: The Art of Setting Money Aside for Future Needs",
      content: "Understand why saving is crucial for financial security. Learn about emergency funds, why they're essential, and how they provide a cushion for unexpected expenses.",
      subsections: [
        {
          title: "The Importance of Saving",
          content: "Learn about emergency funds, why they're essential, and how they provide a cushion for unexpected expenses."
        },
        {
          title: "Types of Savings",
          content: `Differentiate between:\n
            - Emergency Funds: Immediate reserves for unforeseen events.\n
            - Short-Term Savings: For goals within a few years, like vacations or electronics.\n
            - Long-Term Savings: For future aspirations, such as education or retirement.`
        },
        {
          title: "Setting Saving Goals",
          content: "Guidance on establishing realistic and achievable saving goals based on your budget, with milestones to celebrate along the way."
        },
        {
          title: "Saving Techniques",
          content: `Techniques that promote consistent saving habits, including:\n
            - Automatic transfers to savings accounts.\n
            - The 'pay yourself first' method.\n
            - Cutting unnecessary expenses to boost savings.`
        }
      ]
    }
  ]
};

db.collection('modules').add(moduleData)
  .then((docRef) => {
    console.log("Document written with ID: ", docRef.id);
  })
  .catch((error) => {
    console.error("Error adding document: ", error);
  });
