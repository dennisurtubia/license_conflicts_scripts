const fs = require('fs');

const chunk = require('lodash.chunk');

const playwright = require('playwright');
const { projectList } = require('./projects_list');

async function main() {
  const browser = await playwright.chromium.launch({
    headless: true
  });

  const chunked = chunk(projectList, 5);

  for (const projects of chunked) {
    const npmProjects = [];

    const result = projects.map(async (project) => {
      console.log('Project: ', project);

      const page = await browser.newPage();
      await page.goto(`https://github.com/${project}`);

      try {
        await page.locator('text=package-lock.json').textContent({ timeout: 100 });
        npmProjects.push(project);
      } catch (e) {
        await page.locator('text=Whoa there!').textContent({ timeout: 100 });
        await new Promise(r => setTimeout(r, 30000));
      } finally {
        page.close();
      }
    });

    await Promise.all(result);
    fs.appendFileSync('projects.txt', `${npmProjects.join('\n')}\n`);


    await new Promise(r => setTimeout(r, 5000));
  }

  await browser.close();
}

main();
