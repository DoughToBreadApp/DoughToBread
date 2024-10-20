import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyBUTm8ArJUMXK_XFM8gud-jxPe3l83CtFQ",
  authDomain: "doughtobreadapp.firebaseapp.com",
  projectId: "doughtobreadapp",
  storageBucket: "doughtobreadapp.appspot.com",
  messagingSenderId: "275124915852",
  appId: "1:275124915852:web:e0354b0150bba2847535a9"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

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

let sectionCount = 1;
let subsectionCounts: { [key: number]: number } = { 1: 1 };

function updatePreview() {
  const preview = document.getElementById("preview") as HTMLElement;
  const moduleName = (document.getElementById("moduleName") as HTMLInputElement).value;
  const moduleDescription = (document.getElementById("moduleDescription") as HTMLTextAreaElement).value;

  let previewHTML = `
    <h3>${moduleName}</h3>
    <p>${moduleDescription}</p>
  `;

  for (let i = 1; i <= sectionCount; i++) {
    const sectionTitle = (document.getElementById(`section${i}Title`) as HTMLInputElement)?.value;
    const sectionContent = (document.getElementById(`section${i}Content`) as HTMLTextAreaElement)?.value;

    if (sectionTitle && sectionContent) {
      previewHTML += `
        <h4>${sectionTitle}</h4>
        <p>${sectionContent}</p>
      `;

      for (let j = 1; j <= (subsectionCounts[i] || 0); j++) {
        const subsectionTitle = (document.getElementById(`subsection${i}_${j}Title`) as HTMLInputElement)?.value;
        const subsectionContent = (document.getElementById(`subsection${i}_${j}Content`) as HTMLTextAreaElement)?.value;

        if (subsectionTitle && subsectionContent) {
          previewHTML += `
            <h5>${subsectionTitle}</h5>
            <p>${subsectionContent}</p>
          `;
        }
      }
    }
  }

  preview.innerHTML = previewHTML;
}

function addSubsection(sectionIndex: number) {
  subsectionCounts[sectionIndex] = (subsectionCounts[sectionIndex] || 0) + 1;
  const subsectionCount = subsectionCounts[sectionIndex];
  const subsectionsContainer = document.querySelector(`#sections .section:nth-child(${sectionIndex}) .subsections`);

  if (subsectionsContainer) {
    const newSubsection = document.createElement('div');
    newSubsection.className = 'subsection';
    newSubsection.innerHTML = `
      <h4>Subsection ${subsectionCount}</h4>
      <div class="form-group">
        <label for="subsection${sectionIndex}_${subsectionCount}Title">Subsection Title:</label>
        <input type="text" id="subsection${sectionIndex}_${subsectionCount}Title" required>
      </div>
      <div class="form-group">
        <label for="subsection${sectionIndex}_${subsectionCount}Content">Subsection Content:</label>
        <textarea id="subsection${sectionIndex}_${subsectionCount}Content" required></textarea>
      </div>
    `;
    subsectionsContainer.appendChild(newSubsection);

  
    newSubsection.querySelectorAll('input, textarea').forEach(element => {
      element.addEventListener('input', updatePreview);
    });
  }

  updatePreview();
}

function addSection() {
  sectionCount++;
  const sectionsContainer = document.getElementById('sections');

  if (sectionsContainer) {
    const newSection = document.createElement('div');
    newSection.className = 'section';
    newSection.innerHTML = `
      <h3>Section ${sectionCount}</h3>
      <div class="form-group">
        <label for="section${sectionCount}Title">Section Title:</label>
        <input type="text" id="section${sectionCount}Title" required>
      </div>
      <div class="form-group">
        <label for="section${sectionCount}Content">Section Content:</label>
        <textarea id="section${sectionCount}Content" required></textarea>
      </div>
      <div class="subsections"></div>
      <button type="button" class="add-subsection">Add Subsection</button>
    `;
    sectionsContainer.appendChild(newSection);


    newSection.querySelector('.add-subsection')?.addEventListener('click', () => addSubsection(sectionCount));

    newSection.querySelectorAll('input, textarea').forEach(element => {
      element.addEventListener('input', updatePreview);
    });
  }

  subsectionCounts[sectionCount] = 0;
  updatePreview();
}

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('moduleForm') as HTMLFormElement;
  const addSectionButton = document.getElementById('addSection') as HTMLButtonElement;
  const statusMessage = document.getElementById("statusMessage") as HTMLElement;

  form.querySelectorAll('input, textarea').forEach(element => {
    element.addEventListener('input', updatePreview);
  });


  addSectionButton.addEventListener('click', addSection);


  document.querySelector('.add-subsection')?.addEventListener('click', () => addSubsection(1));

  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const newModule: Module = {
      name: (document.getElementById("moduleName") as HTMLInputElement).value,
      description: (document.getElementById("moduleDescription") as HTMLTextAreaElement).value,
      sections: []
    };

    for (let i = 1; i <= sectionCount; i++) {
      const sectionTitle = (document.getElementById(`section${i}Title`) as HTMLInputElement)?.value;
      const sectionContent = (document.getElementById(`section${i}Content`) as HTMLTextAreaElement)?.value;

      if (sectionTitle && sectionContent) {
        const section: Section = {
          title: sectionTitle,
          content: sectionContent,
          subsections: []
        };

        for (let j = 1; j <= (subsectionCounts[i] || 0); j++) {
          const subsectionTitle = (document.getElementById(`subsection${i}_${j}Title`) as HTMLInputElement)?.value;
          const subsectionContent = (document.getElementById(`subsection${i}_${j}Content`) as HTMLTextAreaElement)?.value;

          if (subsectionTitle && subsectionContent) {
            section.subsections.push({
              title: subsectionTitle,
              content: subsectionContent
            });
          }
        }

        newModule.sections.push(section);
      }
    }

    try {
      const docRef = await addDoc(collection(db, "modules"), newModule);
      console.log("Module added with ID:", docRef.id);
      statusMessage.innerText = "Module added successfully!";
      form.reset();
      updatePreview();
    } catch (error) {
      console.error("Error adding module:", error);
      statusMessage.innerText = "Error adding module.";
    }
  });

  updatePreview();
});